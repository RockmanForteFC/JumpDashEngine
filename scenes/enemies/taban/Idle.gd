extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------

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
	owner.is_blocking = true
	$"../../AnimationPlayer".play("idle")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_Area2D_body_entered(body):
	if body is Player:
		if !body.is_dead:
			$"../../AnimationPlayer".play("unhide")
			owner.is_blocking = false
			$"../../Area2D/CollisionShape2D".set_deferred("disabled", true)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ("unhide"):
		emit_signal("finished", "fly")
