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
	$"../../AnimatedSprite".flip_h = true
	$"../../AnimatedSprite/eye".play("Up")
	owner.wall_direction = "right"
	owner.moving_direction = "up"
	get_parent().velocity = Vector2(0, owner.move_speed * Vector2.UP.y)

func _exit():
	get_parent().frame = 0

func _update(delta):
	get_parent().frame += 1
	get_parent().velocity.x = clamp(get_parent().velocity.x + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity,Vector2.UP)
	if get_parent().frame > get_parent().TURN_FRAME_DELAY:
		if !owner.is_on_wall():
			emit_signal("finished","wall-down-moving-right")
		if owner.is_on_ceiling():
			emit_signal("finished", "wall-up-moving-left")
		

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
