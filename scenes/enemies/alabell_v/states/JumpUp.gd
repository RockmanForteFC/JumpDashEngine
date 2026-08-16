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
	owner.current_state = "jump_up"
	$"../../AnimationPlayer".play("JumpUp" + owner.animation_modifier)
	get_parent().velocity.y = -250

func _update(delta):
	get_parent().velocity.y = clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity,Vector2.UP)
	if owner.is_on_ceiling():
		get_parent().velocity.y = 0
	if get_parent().velocity.y <= 0:
		emit_signal("finished","jump_down")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_animation_finished(anim_name):
	pass
