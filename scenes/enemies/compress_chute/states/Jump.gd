extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const HIGH_JUMP_VELOCITY : float = -400.0
const LOW_JUMP_VELOCITY : float = -250.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var jump_type : int
var jumped : bool
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _enter():
	$"../../EnemyAnimations".play("Idle-Jump")
	if get_parent().low_jump_amount < 2 and get_parent().high_jump_amount < 2 :
		jump_type = Physics.rng.randi_range(0,1)
	elif get_parent().low_jump_amount == 2 :
		jump_type = 1
		get_parent().low_jump_amount = 0
	elif get_parent().high_jump_amount == 2 :
		jump_type = 0
		get_parent().high_jump_amount = 0

	if jump_type == 0 :
		get_parent().velocity.y = LOW_JUMP_VELOCITY
		get_parent().velocity.x = 125 * owner.get_facing_direction().x
		get_parent().low_jump_amount += 1
		jumped = true
	elif jump_type == 1 :
		get_parent().velocity.y = HIGH_JUMP_VELOCITY
		get_parent().velocity.x = 100 * owner.get_facing_direction().x
		get_parent().high_jump_amount += 1
		jumped = true

func _update(delta):
	get_parent().velocity.y = \
		clamp(get_parent().velocity.y + Physics.GRAVITY , -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor() and jumped :
		emit_signal("finished","landing")
		jumped = false
	if owner.is_on_ceiling() :
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
