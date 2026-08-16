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
var at_midair : bool = false
var prepare_to_jump : bool
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _enter():
	$"../../EnemyAnimations".play("Idle-Jump")
	owner.face_player()
	$"../../StandingTimer".start()
	
func _update(delta):
	get_parent().velocity.y = \
		clamp(get_parent().velocity.y + Physics.GRAVITY , -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor():
		get_parent().velocity = Vector2.ZERO
	elif not owner.is_on_floor() :
		at_midair = true
		$"../../StandingTimer".stop()
		$"../../EnemyAnimations".play("Idle-Jump")
		prepare_to_jump = false
	if at_midair and owner.is_on_floor() :
		at_midair = false
		emit_signal("finished","landing")
	if owner.is_on_ceiling():
		get_parent().velocity.y = 0

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_StandingTimer_timeout():
	$"../../EnemyAnimations".play("Prepare-Landing")
	prepare_to_jump = true
	owner.face_player()

func _on_animation_finished(anim_name):
	if anim_name == "Prepare-Landing" and prepare_to_jump :
		emit_signal("finished","jump")
		prepare_to_jump = false
