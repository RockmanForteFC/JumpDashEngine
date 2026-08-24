extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const JUMP_HEIGHT:int = -248
const JUMP_SPEED:int = 72

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
	get_parent().velocity.y = JUMP_HEIGHT
	get_parent().velocity.x = owner.get_facing_direction().x * JUMP_SPEED
	$"../../AnimationPlayer".play("jump")

func _update(delta):
	get_parent().velocity.y = \
		clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_ceiling():
		get_parent().velocity.y = 0
	if owner.is_on_floor():
		get_parent().velocity.y = 0
		get_parent().velocity.x = 0
		_popdown()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _popdown():
	$"../../AnimationPlayer".play("popdown")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ("popdown"):
		emit_signal("finished", "idle")
