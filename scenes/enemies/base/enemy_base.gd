tool
extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const Spawner: Resource = preload("res://scenes/enemies/common/spawner.tscn")
const DAMAGE_NUMBER = preload("res://scenes/common/damage_numbers/damage_numbers.tscn")
const SCORE_LABEL = preload("res://scenes/enemies/base/score_label/score_label.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal change_state(state_name)
signal queued_free()
signal temp_lock_open
signal enemy_died()
signal midboss_died
#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(String) var enemy_name: String
export(String) var unique_id: String
export (Physics.Element)var element:int = Physics.Element.neutral
export (Physics.Damage)var damage_type:int = Physics.Damage.contact
export(int) var hit_points_max := 20
export(int) var contact_damage := 5
export(int) var projectile_damage := 5
export(bool) var can_respawn := true
export(int) var spawn_count_max := -1
export(float) var spawn_timer := 0.0
export(bool) var flip_direction:bool setget set_flip_direction
export(int) var score := 100
export(bool) var is_locking_enemy:= false
export(bool) var is_midboss := false
export(bool) var drops_items := true
export(String, "normal","large","snow","glitch_small") var explosion_type:String = "normal"
export(String, "small", "medium", "large", "extralarge") var enemy_size
# this needs to be an export so it works in animation player
export(bool)  var has_iframes:bool = false
var _show_score:bool = false
var _hit_points: int
var _is_collidable := true
var _player_collision_area: Area2D
var _external_damaging_area: Area2D
var _timer: Timer
var spawn_info := {}
var is_dead := false
var is_blocking := false


onready var _hit_sound: AudioStreamPlayer = get_node("Audio/Hit")
onready var _animations: AnimationPlayer = $BaseAnimations
onready var _start_pos: Vector2 = position
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:
	if unique_id == "" or unique_id == null:
		unique_id = str(get_instance_id())
	if !$IFrames.is_connected("timeout",self,"_disable_iframes"):
		$IFrames.connect("timeout",self,"_disable_iframes")
	if !is_connected("change_state", $StateMachine, "_change_state"):
		connect("change_state", $StateMachine, "_change_state")
	if has_node("Hitbox"):
		_player_collision_area = $Hitbox
		if !_player_collision_area.is_connected("body_entered", self, "_on_hit"):
			_player_collision_area.connect("body_entered", self, "_on_hit")
		if !_player_collision_area.is_connected("area_entered", self, "_on_lava"):
			_player_collision_area.connect("area_entered", self, "_on_lava")
	if has_node("Hurtbox"):
		_external_damaging_area = $Hurtbox
	_hit_points = hit_points_max
	if is_midboss:
		for gate in get_tree().get_nodes_in_group("miniboss_gate"):
			if !is_connected("midboss_died",gate, "_on_miniboss_dead"):
				connect("midboss_died",gate, "_on_miniboss_dead")
		if get_parent() is Section:
			connect("midboss_died",get_parent(),"_on_midboss_death")
		else:
			if get_parent().get_parent() is Section:
				if !is_connected("midboss_died",get_parent().get_parent(),"_on_midboss_death"):
					connect("midboss_died",get_parent().get_parent(),"_on_midboss_death")
	add_to_group("Enemies")
	if !$PreciseVisibilityNotifier2D.is_connected("camera_exited",self,"on_camera_exited"):
		$PreciseVisibilityNotifier2D.connect("camera_exited",self,"on_camera_exited")

func _physics_process(delta: float) -> void:
	#occasionally an enemy can slip by the bounds of the screen detection. this is just a safty check
	#if not $PreciseVisibilityNotifier2D.is_on_screen() and not is_midboss:
	#	queue_free()

	if _player_collision_area:
		for body in _player_collision_area.get_overlapping_bodies():
			if body is Player and _is_collidable:
					body.on_hit(contact_damage, damage_type,element)
	if _external_damaging_area:
		for body in _external_damaging_area.get_overlapping_bodies():
			if body is Player and _is_collidable:
				if not is_dead:
					body.on_hit(contact_damage, damage_type,element)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func get_distance_from_player():
	var h_distance:float = 0.0
	if  global_position.x < PlayerValues.player.global_position.x:
		h_distance = PlayerValues.player.global_position.x - global_position.x
	else:
		h_distance = global_position.x - PlayerValues.player.global_position.x

	var v_distance:float = 0.0
	if  global_position.y < PlayerValues.player.global_position.y:
		v_distance = PlayerValues.player.global_position.y - global_position.y
	else:
		v_distance = global_position.y - PlayerValues.player.global_position.y
	return Vector2(h_distance,v_distance)

func face_player():
	if !is_dead and (PlayerValues.player and  is_instance_valid(PlayerValues.player)) and not PlayerValues.is_teleporting and $Hitbox:
		var vector_to_player: Vector2 = PlayerValues.player.global_position - $Hitbox.global_position
		if sign(get_facing_direction().x) != sign(vector_to_player.x):
			toggle_flip_h()

func move_and_slide(linear_velocity: Vector2, up_direction: Vector2 = Vector2( 0, 0 ), stop_on_slope: bool = false, max_slides: int = 4, floor_max_angle: float = 0.785398, infinite_inertia: bool = true):
	if !Physics.pause_enemies:
		.move_and_slide(linear_velocity, up_direction, stop_on_slope, max_slides, floor_max_angle, infinite_inertia)

func toggle_flip_h() -> void:
	$Sprite.flip_h = !$Sprite.flip_h
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	$Collider.position.x *= -1
	$Hitbox/CollisionShape2D.position.x *= -1
	$BaseShootPos.position.x *= -1

func set_flip_direction(value: bool) -> void:
	$Sprite.flip_h = value
	$AnimatedSprite.flip_h = value
	if value == true:
		$Collider.position.x *= -1
		$Hitbox/CollisionShape2D.position.x *= -1
		$BaseShootPos.position.x *= -1
	flip_direction = value

func set_velocity(vel):
	$StateMachine.velocity.y = vel

func set_state(state:String):
	emit_signal("change_state", state)

func get_facing_direction() -> Vector2:
	return Vector2.RIGHT if $Sprite.flip_h else Vector2.LEFT

func start_yield_timer(time: float) -> Timer:
	_timer = Timer.new()
	add_child(_timer)
	_timer.start(time)
	return _timer

func queue_free() -> void:
	emit_signal("queued_free")
	if _timer and _timer.time_left > 0:
		yield(_timer, "timeout")
	.queue_free()

func on_crush()->void:
	if not is_dead and get_collision_layer_bit(Bitmask.crushable):
		set_collision_mask_bit(Bitmask.land_gimick, false)
		_hit_sound.play()
		_die()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _disable_iframes():
	has_iframes = false

# instead of hiding an enemy when it dies. it will get replaced
# with a low-resource spawner that will provide new enemies to kill while saving on potential lag
func _replace_with_spawner() -> void:
	spawn_info["flip_direction"] = flip_direction
	spawn_info["is_locking_enemy"] = is_locking_enemy
	spawn_info["projectile_damage"] = projectile_damage
	spawn_info["contact_damage"] = contact_damage
	spawn_info["modulate"] = modulate
	spawn_info["hit_points_max"] = hit_points_max
	spawn_info["score"] = score
	spawn_info["enemy_name"] = enemy_name
	spawn_info["unique_id"] = str(get_instance_id()) if not unique_id else unique_id
	spawn_info["enemy_size"] = enemy_size
	spawn_info["explosion_type"] = explosion_type
	spawn_info["drops_items"] = drops_items
	spawn_info["element"] = element
	spawn_info["scale"] = scale

	if not can_respawn:
		return

	var spawner: Position2D = Spawner.instance()
	spawner.packed_scene_ref = load(filename)
	spawner.position = _start_pos
	spawner.spawn_info = spawn_info
	spawner.spawn_count_max = spawn_count_max
	spawner.spawn_timer = spawn_timer
	get_parent().add_child(spawner)
	queue_free()

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_camera_exited():
	if is_locking_enemy:
		emit_signal("temp_lock_open")
	queue_free()

func _force_damage(damage):
	if not is_dead and not has_iframes:
		_hit_sound.play()
		has_iframes = true
		$IFrames.start()
		_animations.play("Blink")
		var prevent_appending_to_user_stats = false
		_take_damage(damage,  prevent_appending_to_user_stats)

func _external_damage(damage):
	if not is_dead and not has_iframes:
		_hit_sound.play()
		has_iframes = true
		$IFrames.start()
		_animations.play("Blink")
		var prevent_appending_to_user_stats = true
		_take_damage(damage,  prevent_appending_to_user_stats)

func _on_hit(body: PhysicsBody2D) -> void:
	if body and body.is_in_group("PlayerWeapons"):
		body.did_hit_enemy = true
		if "consumed" in body and body.consumed:
			return
		elif is_blocking:
			if not body.is_piercing:
				body.reflect()
		else:
			if not is_dead:
				_hit_sound.play()
				if body.is_in_group("SonSonShooterP1"):
					_show_score = true
				var buster_damage: int = 1 if not "damage" in body else body.damage
				if buster_damage <= _hit_points:
					if not body.is_piercing:
						body.queue_free()
					elif body.is_piercing and body.breaks_on_enemy:
						body.queue_free()
				_animations.play("Blink")

				var was_beast_net = body.is_in_group("BeastNetP1")
				if check_is_weakness(body.element):
					if buster_damage == 0:
						buster_damage = 1
					buster_damage *= 2
				_take_damage(buster_damage,false, was_beast_net)
	if body and body.is_in_group("Trap"):
		if not is_dead:
			_external_damage(body.damage)

func _take_damage(damage: int, prevent_appending_to_user_stats:bool = false, was_beast_net:bool = false) -> void:
	if Config.show_damage_values:
		var damage_number = DAMAGE_NUMBER.instance()
		damage_number.damage = str(damage)
		damage_number.position = position
		get_parent().add_child(damage_number)

	_hit_points -= damage
	if _hit_points < 1:
		_die(prevent_appending_to_user_stats, was_beast_net)
	else:
		_show_score = false

func _die(prevent_appending_to_user_stats:bool = false, was_beast_net:bool = false) -> void:
	is_dead = true
	if is_locking_enemy:
		emit_signal("temp_lock_open")
	if  not prevent_appending_to_user_stats:
		Score.change(score)
		emit_signal("enemy_died")
	else: #prevent item drops from enemies thar you dont kill yourself.
		drops_items = false
	_is_collidable = false  # Player can no longer collide with enemy.
	if _player_collision_area:
		# Is no longer hittable by player projectiles.
		_player_collision_area.set_collision_layer_bit(Bitmask.projectile, false)
		_player_collision_area.set_collision_layer_bit(Bitmask.player, false)
	emit_signal("change_state", "death")

func _on_in_in_view(viewport):
	if is_locking_enemy:
		for door in get_tree().get_nodes_in_group("BossDoors"):
			door.temp_lock = true
			connect("temp_lock_open", door ,"on_locking_enemy_dead")

func check_is_weakness(body_element:int) -> bool:
	var weakness = false
	if body_element == Physics.Element.neutral:
		return false

	if body_element == Physics.Element.dark and element == Physics.Element.light:
		weakness = true
	elif body_element == Physics.Element.light and element == Physics.Element.dark:
		weakness = true

	elif body_element == Physics.Element.fire and element == Physics.Element.ice:
		weakness = true

	elif body_element == Physics.Element.ice and element == Physics.Element.leaf:
		weakness = true

	elif body_element == Physics.Element.leaf and element == Physics.Element.ground:
		weakness = true

	elif body_element == Physics.Element.ground and element == Physics.Element.electric:
		weakness = true

	elif body_element == Physics.Element.electric and element == Physics.Element.water:
		weakness = true

	elif body_element == Physics.Element.water and element == Physics.Element.fire:
		weakness = true

	elif body_element == Physics.Element.blade and element == Physics.Element.leaf:
		weakness = true
	elif body_element == Physics.Element.chemical and element == Physics.Element.ground:
		weakness = true
	elif body_element == Physics.Element.wind and element == Physics.Element.fire:
		weakness = true
	return weakness

func _on_lava(area):
	if area:
		if area.get_collision_layer_bit(Bitmask.lava):
			if not is_dead:
				_die(true,false)
