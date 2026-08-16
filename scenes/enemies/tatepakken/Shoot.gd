extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const BULLET:Resource = preload("res://scenes/enemies/mets/mm9_met/met_9_shot.tscn")
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
	$"../../AnimationPlayer".play("Unhide")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _shoot():
	var b = BULLET.instance()
	var pos = $"../../Position2D"
	owner.get_parent().call_deferred("add_child", b)
	b.damage = owner.projectile_damage
	b.speed = 128 
	b.direction = owner.get_facing_direction()
	b.set_deferred("global_position", pos.global_position)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ("Unhide"):
		emit_signal("finished", "idle")
