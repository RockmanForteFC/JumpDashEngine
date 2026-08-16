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
	$"../../AnimatedSprite/eye".play("Right")
	owner.wall_direction = "up"
	owner.moving_direction = "right"
	get_parent().velocity = Vector2(owner.move_speed * Vector2.RIGHT.x, 0)

func _exit():
	get_parent().frame = 0

func _update(delta):
	get_parent().frame += 1
	get_parent().velocity.y = clamp(get_parent().velocity.y - Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity,Vector2.UP)
	if get_parent().frame > get_parent().TURN_FRAME_DELAY:
		if !owner.is_on_ceiling():
			emit_signal("finished","wall-left-moving-up")
		if owner.is_on_wall():
			emit_signal("finished", "wall-right-moving-down")
		

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
