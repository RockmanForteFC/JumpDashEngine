extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const STEP_SIZE:float = 25.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var low_position:Vector2
var high_position:Vector2
var can_go_up:bool = true 
var is_riding:bool = false
export(float,10.0,100.0,2.0) var  speed:float = 26.0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	set_physics_process(false)
	low_position = global_position
	high_position = global_position
	high_position.y -= (Physics.TILE_SIZE.y *4)
	
func _physics_process(delta):
	is_riding = false
	if $no_player_zone.get_overlapping_bodies().size() > 0 :
		can_go_up = false
	else:
		can_go_up = true
		
	if can_go_up:
		for body in $player_detector.get_overlapping_bodies():
			if body and body is Player and body.is_on_floor():
				is_riding = true 
	else:
		is_riding = false 

	if global_position != low_position and global_position != high_position:
		$AnimatedSprite.play("Moving")
	else:
		$AnimatedSprite.play("Stopped")

	if is_riding:
		global_position.y = clamp(global_position.y - (speed * delta), high_position.y, low_position.y)
	else:
		global_position.y = clamp(global_position.y + (speed * delta), high_position.y, low_position.y)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_entered():
	set_physics_process(true)

func _on_PreciseVisibilityNotifier2D_camera_exited():
	set_physics_process(false)
