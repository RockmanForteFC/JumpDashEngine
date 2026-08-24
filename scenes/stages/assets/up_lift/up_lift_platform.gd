extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SPEED_MAX = 140
const SPEED_MIN = 0
const SPEED_STEP = 4
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

var current_speed = SPEED_MIN
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.play("default")
	set_physics_process(true)


func _physics_process(delta):
	current_speed = clamp( current_speed + SPEED_STEP, SPEED_MIN,SPEED_MAX )
	global_position.y += delta * (current_speed * Vector2.UP.y)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func activate():
	set_physics_process(true)
	show()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()

