extends Area2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var frame_to_check = 1
var current_frame = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	frame_to_check = Physics.rng.randi_range(1,2)

func _physics_process(delta):
	if current_frame == frame_to_check:
		if monitoring:
			for body in get_overlapping_bodies():
				if body is Player:
					if body.is_on_floor():
						body.has_low_friction = true
		current_frame = -1
	current_frame += 1

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_IceFloor_body_exited(body):
	if body is Player:
		body.has_low_friction = false
