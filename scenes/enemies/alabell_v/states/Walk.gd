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
	get_parent().velocity.x = owner.get_facing_direction().x * 60
	get_parent().velocity.y = 0
	owner.current_state = "walk"
	$"../../AnimationPlayer".play("Walk" + owner.animation_modifier)


func _update(delta):
	get_parent().velocity.y = clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity,Vector2.UP)
	if owner.is_on_floor():
		get_parent().velocity.y = 0
	if !owner.is_on_floor():
		emit_signal("finished","jump_down")
	if owner.is_on_wall():
		owner.toggle_flip_h()
		get_parent().velocity.x = owner.get_facing_direction().x * 60

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
