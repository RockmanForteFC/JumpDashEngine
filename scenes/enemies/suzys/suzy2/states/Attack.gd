extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const VERTICAL_VELOCITY: float = 200.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var is_midair:bool = false
var direction:int
var started_moving:bool = false

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _enter():
	if owner.starting_direction == "Down" and started_moving == false:
		direction = -1
		started_moving = true
	elif started_moving == false :
		direction = 1
		started_moving = true
	direction *= -1
	if direction == -1:
		$"../../AnimationPlayer".play("Attack_Up")
	else:
		$"../../AnimationPlayer".play("Attack_Down")

func _update(delta):
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if not (owner.is_on_floor() or owner.is_on_ceiling()):
		is_midair = true
	if (owner.is_on_floor() or owner.is_on_ceiling()) and is_midair:
		is_midair = false
		get_parent().velocity = Vector2.ZERO
		$"../../AnimationPlayer".play("Stop")
	if owner.is_on_floor() and direction == 1:
		get_parent().velocity = Vector2.ZERO
		$"../../AnimationPlayer".play("Stop")
	elif owner.is_on_ceiling() and direction == -1:
		get_parent().velocity = Vector2.ZERO
		$"../../AnimationPlayer".play("Stop")

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
	if anim_name == "Attack_Up" or anim_name == "Attack_Down" :
		get_parent().velocity.y = VERTICAL_VELOCITY*direction
	elif anim_name == "Stop" :
		emit_signal("finished","idle")
