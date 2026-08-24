extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SHOOT_DELAY: float = 0.3
const Bullet: Resource = preload("res://scenes/enemies/mets/mm9_met/met_9_shot.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	 pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter() -> void:
	owner.is_blocking = false
	$"../../EnemyAnimations".play("Shoot")
	yield(owner.start_yield_timer(SHOOT_DELAY), "timeout")

	if owner.is_dead:
		return

	var bullet_pos: Vector2 = $"../../BaseShootPos".global_position
	var bullet: Node = Bullet.instance()
	bullet.damage = owner.projectile_damage
	bullet.position = bullet_pos
	bullet.direction = owner.get_facing_direction()
	Physics.current_stage.add_child(bullet)

	bullet = Bullet.instance()
	bullet.damage = owner.projectile_damage
	bullet.position = bullet_pos
	bullet.direction = Vector2.DOWN + owner.get_facing_direction()
	Physics.current_stage.add_child(bullet)

	bullet = Bullet.instance()
	bullet.damage = owner.projectile_damage
	bullet.position = bullet_pos
	bullet.direction = Vector2.UP + owner.get_facing_direction()
	Physics.current_stage.add_child(bullet)




#fall down to the floor
func _update(delta: float) -> void:
	get_parent().velocity.y = \
		clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor():
		get_parent().velocity = Vector2.ZERO

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Shoot":
		emit_signal("finished", "idle")
