extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
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
func _enter():
	owner.is_blocking = false
	$"../../AnimationPlayer".play("popup")
	$"../../shot_delay".start()
func _update(delta):
	get_parent().velocity.y = \
		clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor():
		get_parent().velocity.y = 0
		get_parent().velocity.x = 0
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func shoot():
	if !owner.is_dead:
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
		$"../../wait_time".start()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ("popdown"):
		emit_signal("finished", "idle")

func _on_shot_delay_timeout():
	shoot()

func _on_wait_time_timeout():
	$"../../AnimationPlayer".play("popdown")
