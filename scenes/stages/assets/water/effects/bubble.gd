extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const check_for_bodies_after_frames:int = 3
const BUBBLE_SPEED = -50
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
#to create a wobble in the water we will shift it back and forth every few frames
var frame:int = 0
var velocity:Vector2 = Vector2()
var water_body

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if get_tree().get_nodes_in_group("Bubble").size() >= 1:
		queue_free()
	add_to_group("Bubble")

func _process(delta):
	if water_body != null and not water_body.is_in_group("Water"):
		queue_free()
	#after 3 frames of time, check if the bubble was spawned in a bad position.
	if frame >= check_for_bodies_after_frames:
		if $Water_Detector.get_overlapping_areas().size() == 0:
			queue_free()
	frame += 1
	velocity.y = BUBBLE_SPEED
	if frame == 5:
		velocity.x = 5
	if frame == 10:
		velocity.x = -5
	if frame == 15:
		velocity.x =-5
	if frame == 20:
		velocity.x = 5
		frame = 0
	move_and_slide(velocity,Vector2.UP)

	if is_on_ceiling():
		queue_free()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_PreciseVisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Water_Detector_body_entered(body):
	water_body = body
