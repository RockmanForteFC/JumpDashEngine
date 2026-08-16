extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const PUSH_SPEED = 60
const PUSH_HEIGHT= 100
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var push:Vector2
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _enter():
	owner.current_state = "push"
	push = Vector2(owner.push_direction.x * PUSH_SPEED, -PUSH_HEIGHT)
	$"../../AnimationPlayer".play("JumpDown" + owner.animation_modifier)

func _update(delta):
	push.y = clamp(push.y + Physics.GRAVITY,-Physics.FALL_SPEED_MAX,Physics.FALL_SPEED_MAX)
	owner.move_and_slide(push,Vector2.UP)
	if owner.is_on_floor():
		emit_signal("finished","walk")

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
