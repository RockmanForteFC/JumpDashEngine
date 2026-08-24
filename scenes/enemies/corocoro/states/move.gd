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
var last_jump_x:float = 0.0
var stagnant_location_check:float = 0.0
var stagnant_count = 0
var stagnant_location_limit:int = 100
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter():
	$"../../EnemyAnimations".play("Move")

func _update(delta):
	get_parent().velocity.x = get_parent().MOVE_SPEED * owner.get_facing_direction().x
	get_parent().velocity.y = clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)

	if owner.is_on_floor():
		get_parent().velocity.y = 0

	if owner.is_on_wall():
		owner.flip()

	elif not $"../../FloorDetector1".is_colliding() and not $"../../FloorDetector2".is_colliding() :
		emit_signal("finished", "jump")

	elif $"../../WallDetector".is_colliding():
		emit_signal("finished", "jump")
#-------------------------------------------------
#      Connections
#-------------------------------------------------
