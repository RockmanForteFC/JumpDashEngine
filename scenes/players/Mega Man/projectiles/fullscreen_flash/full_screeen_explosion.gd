extends CanvasLayer

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var projectile_damage:int = 9
var damage_type = Physics.Damage.screen_wide
var element = Physics.Element.electric
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("Explode")
	if PlayerValues.player != null:
		PlayerValues.player.on_hit(projectile_damage, damage_type, element)
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
	queue_free()
