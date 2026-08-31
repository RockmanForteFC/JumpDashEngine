extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const BULLET = preload("res://scenes/enemies/mets/mm1_met/met_1_shot.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var shoot_count = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _enter():
	$"../../AnimationPlayer".play("Shoot")


#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func shoot():
	if not owner.is_dead:
		if shoot_count == 0:
			var bullet = BULLET.instance()
			bullet.damage = owner.projectile_damage
			bullet.position = $"../../BaseShootPos".global_position
			bullet.direction = Vector2.UP + owner.get_facing_direction()
			Physics.current_stage.add_child(bullet)
		if shoot_count == 1:
			var bullet = BULLET.instance()
			bullet.damage = owner.projectile_damage
			bullet.position = $"../../BaseShootPos".global_position
			bullet.direction = owner.get_facing_direction()
			Physics.current_stage.add_child(bullet)
		if shoot_count == 2:
			var bullet = BULLET.instance()
			bullet.damage = owner.projectile_damage
			bullet.position = $"../../BaseShootPos".global_position
			bullet.direction = Vector2.DOWN + owner.get_facing_direction()
			Physics.current_stage.add_child(bullet)
		shoot_count += 1
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_animation_finished(anim_name):
	if anim_name == "Shoot":
		shoot_count = 0
		emit_signal("finished", "close")
