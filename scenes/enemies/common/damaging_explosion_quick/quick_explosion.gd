extends Area2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(int) var damage:int = 3
export(Physics.Damage) var damage_type:int = Physics.Damage.projectile
export(Physics.Element) var element:int = Physics.Element.fire
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimationPlayer.play("explode")
	$AudioStreamPlayer.play()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

	if $AudioStreamPlayer.playing:
		yield($AudioStreamPlayer, "finished")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_explosion_body_entered(body):
	if body is Player:
		body.on_hit(damage, damage_type, element)


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if $AudioStreamPlayer.playing:
		hide()
		yield($AudioStreamPlayer, "finished")
	queue_free()
