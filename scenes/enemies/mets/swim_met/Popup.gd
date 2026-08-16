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
	owner.is_blocking = false
	$"../../AnimationPlayer".play("popup")
	
func _update(delta):
	get_parent().velocity.y = clamp(get_parent().velocity.y + Physics.GRAVITY_WATER, -Physics.FALL_SPEED_MAX_IN_WATER, Physics.FALL_SPEED_MAX_IN_WATER)
	if owner.is_on_floor():
		get_parent().velocity.y = 0
		get_parent().velocity.x = 0
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
	if anim_name == ("popup"):
		if get_parent().is_in_water:
			emit_signal("finished","swimming")
		else:
			$"../../AnimationPlayer".play("popdown")
	if anim_name == ("popdown"):
		emit_signal("finished", "idle")

