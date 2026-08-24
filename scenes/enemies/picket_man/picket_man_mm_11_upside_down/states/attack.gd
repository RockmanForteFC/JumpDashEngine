extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const PICK = preload("res://scenes/enemies/picket_man/picket_man_mm_11_upside_down/pick_upside_down.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
#var current_attack_count:int = 0
#var attack_limit:int = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$"../../MultiAttackDelay".wait_time = 0.275

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _spawn_pickax():
	if !owner.is_dead:
		var pick = PICK.instance()
		pick.global_position = $"../../BaseShootPos".global_position
		pick.distance = owner.get_distance_from_player()
		pick.direction = owner.get_facing_direction()
		pick.element = Physics.Element.neutral
		pick.damage_type = Physics.Damage.projectile
		pick.damage = owner.projectile_damage
		Physics.current_stage.call_deferred("add_child", pick)

func _enter():
	if get_parent().attack_limit == 0:
		get_parent().attack_limit = Physics.rng.randi_range(owner.min_thrown,owner.max_thrown)
		get_parent().current_attack_count = 1
		owner.face_player()
	$"../../EnemyAnimations".play("Attack")

func _update(delta):
	get_parent().velocity.y = \
	clamp(get_parent().velocity.y - Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_ceiling():
		get_parent().velocity = Vector2.ZERO
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_animation_finished(anim_name):
	if anim_name == "Attack":
		$"../../EnemyAnimations".play("RESET")
		if get_parent().current_attack_count == get_parent().attack_limit:
			get_parent().attack_limit = 0
			emit_signal("finished", "idle")
		else:
			$"../../MultiAttackDelay".start()

func _on_timeout():
	get_parent().current_attack_count += 1
	owner.face_player()
	emit_signal("finished", "attack")
