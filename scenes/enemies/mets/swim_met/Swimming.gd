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
	$"../../AnimationPlayer".play("swim")

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

func _update(delta):
	get_parent().velocity.y = -75
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if get_parent().is_top_of_water:
		shoot()
		emit_signal("finished", "descending")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ("swim"):
		emit_signal("finished", "descending")
