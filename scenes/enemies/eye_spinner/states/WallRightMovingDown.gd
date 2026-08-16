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

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _enter():
	$"../../AnimatedSprite/eye".play("Down")
	owner.wall_direction = "right"
	owner.moving_direction = "down"
	get_parent().velocity = Vector2(0, owner.move_speed * Vector2.DOWN.y)

func _exit():
	get_parent().frame = 0

func _update(delta):
	get_parent().frame += 1 
	get_parent().velocity.x = clamp(get_parent().velocity.x + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity,Vector2.UP)
	if get_parent().frame > get_parent().TURN_FRAME_DELAY:
		if !owner.is_on_wall():
			emit_signal("finished","wall-up-moving-right")
		if owner.is_on_floor():
			emit_signal("finished", "wall-down-moving-left")
		

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_animation_finished(anim_name):
	pass
