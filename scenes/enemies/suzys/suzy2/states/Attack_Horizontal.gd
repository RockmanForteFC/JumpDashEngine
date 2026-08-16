extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const HORIZONTAL_VELOCITY: float = 200.0
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
func get_which_wall_collided():
	for i in range(owner.get_slide_count()):
		var collision = owner.get_slide_collision(i)
		if collision.normal.x > 0:
			return "left"
		elif collision.normal.x < 0:
			return "right"
	return "none"

func _ready():
	pass

func _enter():
	if owner.starting_direction == "Right" and started_moving == false:
		direction = -1
		started_moving = true
	elif started_moving == false :
		direction = 1
		started_moving = true
	direction *= -1
	if direction == -1:
		$"../../AnimationPlayer".play("Attack_Left")
	else:
		$"../../AnimationPlayer".play("Attack_Right")

func _update(delta):
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if not owner.is_on_wall():
		is_midair = true
	if owner.is_on_wall() and is_midair:
		is_midair = false
		get_parent().velocity = Vector2.ZERO
		$"../../AnimationPlayer".play("Stop")
	if get_which_wall_collided() == "left" and direction == -1:
		get_parent().velocity = Vector2.ZERO
		$"../../AnimationPlayer".play("Stop")
	elif get_which_wall_collided() == "right" and direction == 1:
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
	if anim_name == "Attack_Left" or anim_name == "Attack_Right" :
		get_parent().velocity.x = HORIZONTAL_VELOCITY*direction
	elif anim_name == "Stop" :
		emit_signal("finished","idle")
