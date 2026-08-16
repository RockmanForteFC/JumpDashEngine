extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const DAMAGE_NUMBER = preload("res://scenes/common/damage_numbers/damage_numbers.tscn")

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal change_state(state_name)
signal hit_points_changed(_hit_points)
signal boss_ready()
signal boss_died()
signal start_dialog(boss_name)
#-------------------------------------------------
#      Properties
#-------------------------------------------------
export (Physics.Element)var element:int = Physics.Element.neutral
export (Physics.Damage)var damage_type:int = Physics.Damage.contact
export(int) var contact_damage := 3
export(Array, String) var primary_weakness = [""]
export(Array, String) var secondary_weakness = []
export(Array, String) var immunity = [""]
export(int) var score_value := 1500
export(Color) var boss_color := Color("f8d878")
export(Color) var boss_color_inside := Color("ffffff")

var _hit_points: int = 99999
var _start_pos: Vector2
var _is_blocking: bool
var _is_collidable: bool
export var is_invincible: bool
var is_dead: bool
var is_restarting: bool

onready var _base_width: int = Config.DEFAULT_WINDOW_WIDTH
onready var _animated_sprite: AnimatedSprite = $"CharacterSprites/AnimatedSprite"
var life_bar: Control
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready() -> void:
	add_to_group("Bosses")
	if !is_connected("change_state", $StateMachine, "_change_state"):
		connect("change_state", $StateMachine, "_change_state")

	if !$Area2D.is_connected("body_entered", self, "_on_hit"):
		$Area2D.connect("body_entered", self, "_on_hit")
	_start_pos = global_position
	
func _physics_process(delta: float) -> void:
	if $Area2D:
		for body in Physics.get_overlapping_bodies($Area2D):
			if body is Player and _is_collidable:
				body.on_hit(contact_damage,damage_type,element)
			if body.is_in_group("PlayerWeapons"):
				_on_hit(body)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func reset() -> void:
	
	is_restarting = true
	emit_signal("change_state", "await")
	$StateMachine.set_active(false)
	_animated_sprite.play("Idle")
	show()
	_hit_points = 99999
	is_dead = false
	_animated_sprite.hide()
	global_position = _start_pos
	is_invincible = true
	_is_blocking = false
	_animated_sprite.flip_h = false
	_animated_sprite.position = Vector2(0, -256)

func die() -> void:
	Physics.is_in_pausible_state = false
	is_dead = true
	hide()
	_is_collidable = false
	emit_signal("change_state", "death")
	_cleanup_and_report_death(0.75)

func set_facing_direction(dir: Vector2) -> void:
	_animated_sprite.flip_h = true if dir == Vector2.RIGHT else false
	
func get_facing_direction() -> Vector2:
	return Vector2.RIGHT if _animated_sprite.flip_h else Vector2.LEFT

func face_other_way():
	set_facing_direction(get_facing_direction() * Vector2(-1,0))
	
func face_player() -> void:
	if PlayerValues.player is Player:
		set_facing_direction(Vector2(sign(PlayerValues.player.global_position.x - global_position.x), 0))

func continue_ready():
	if $StateMachine.current_state == get_node("StateMachine/Ready"):
		yield($StateMachine.current_state.continue_ready(), "completed")
		_set_activated(true)

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _take_damage(damage: int) -> void:
	_hit_points -= damage
	emit_signal("hit_points_changed", _hit_points)
	if Config.show_damage_values:
		var damage_number = DAMAGE_NUMBER.instance()
		damage_number.damage = str(damage)
		damage_number.position = position
		get_parent().add_child(damage_number)
	if _hit_points < 1:
		die()
		
func _heal_damage(damage:int) ->void:
	_hit_points = clamp(_hit_points + damage, 0, 28)
	emit_signal("hit_points_changed", _hit_points)
	if Config.show_damage_values:
		var damage_number = DAMAGE_NUMBER.instance()
		damage_number.damage = "+" + str(damage)
		damage_number.position = position
		get_parent().add_child(damage_number)
	if _hit_points < 1:
		die()


func _switch_side() -> void:
	global_position.x -= (global_position - \
			Physics.current_stage.current_camera.get_camera_screen_center()).x * 2
	if get_facing_direction() == Vector2.RIGHT:
		set_facing_direction(Vector2.LEFT)
	else:
		set_facing_direction(Vector2.RIGHT)

func _cleanup_and_report_death(timeout: float = 0.0) -> bool:
	_deactivate_boss_projectiles()
	if timeout > 0.0:
		yield(get_tree().create_timer(timeout, false), "timeout")
	var is_player_alive: bool = !PlayerValues.player.is_dead
	if is_player_alive and is_inside_tree():
		Score.change(score_value)
		get_tree().call_group("BossAudio", "stop")
		emit_signal("boss_died")
	return is_player_alive

func _deactivate_boss_projectiles() -> void:
	get_tree().call_group("BossProjectile", "propagate_call", "set_monitoring", [ false ])
	get_tree().call_group("BossProjectile", "queue_free")

func _set_activated(value: bool) -> void:
	if $Area2D.monitoring != value:
		call_deferred("propagate_call", "set_monitoring", [ value ])

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_boss_entered() -> void:
	$CharacterSprites.show()
	_hit_points = 0
	yield(get_tree(),"idle_frame")
	life_bar = Physics.current_stage.get_node("UI/MarginContainer/HealthBar/BossBar")
	life_bar.color = boss_color
	life_bar.color_inside = boss_color_inside
	_hit_points = PlayerValues.MAX_HEALTH
	if not is_connected("hit_points_changed", life_bar, "on_hit_points_changed"):
		connect("hit_points_changed", life_bar, "on_hit_points_changed")
	if PlayerValues.player is Player and abs(global_position.x - PlayerValues.player.global_position.x) < _base_width / 2.0:
		_switch_side()
	$StateMachine.initialize($"StateMachine/Ready".get_path())

func _force_hit(key_name:String) -> void:
		if immunity.has(key_name):
			return 
		else:
			if !is_dead:
				#by default all damage should be 1 on bosses. 
				var damage = 1
				_play_hit_feedback(self, true)
				var multiplier = 1
				if primary_weakness.has(key_name):
					multiplier *= 28
				elif secondary_weakness.has(key_name):
					multiplier *= 2
				if !is_invincible:
					is_invincible = true
					_take_damage(damage * multiplier)

func _on_hit(body: PhysicsBody2D) -> void:
	if body and body.is_in_group("PlayerWeapons"):
		body.did_hit_enemy = true
		if _is_blocking:
			if not body.is_piercing:
				body.reflect()
		elif immunity.has(body.key_name):
			if not body.is_piercing:
				body.reflect()
		else:
			if !is_dead:
				#by default all damage should be 1 on bosses. 
				var damage = 1
				if body.key_name == "mega_buster":
					damage = body.damage
				if not body.is_piercing:
					body.queue_free()
				elif body.is_piercing and body.breaks_on_enemy:
					body.queue_free()
				_play_hit_feedback(body)
				var multiplier:int = 1
				if primary_weakness.has(body.key_name):
					if body.key_name == "tremor_pulse":
						multiplier = 5
						if body.is_upgraded:
							multiplier = 9
					elif body.key_name == "wrecking_beam":
						multiplier = 5
					else:
						multiplier = 3
				elif secondary_weakness.has(body.key_name):
					multiplier = 2
				if !is_invincible:
					is_invincible = true
					_take_damage(damage * multiplier)

func _begin_taunt():
	emit_signal("begin_taunt")
	$CharacterSprites/AnimatedSprite.material.set_shader_param("is_dark", false)
	$CharacterSprites/Sprite.material.set_shader_param("is_dark", false)

func _play_hit_feedback(body: Node, force: bool = false) -> void:
	if body.is_queued_for_deletion() or !is_invincible or force:
		$Audio/Hit.play()
	$AnimationHit.play("Hit")

func _on_BossBase_change_state(state_name: String) -> void:
	if state_name == "await" or state_name == "death":
		_set_activated(false)

func _on_hit_animation_finished(anim_name: String) -> void:
	if anim_name == "Hit":
		self.is_invincible = not $Area2D.monitoring
