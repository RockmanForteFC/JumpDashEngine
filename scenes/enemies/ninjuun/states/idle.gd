extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const POP_UP_SPEED:float = -350.0
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
	$"../../Sprite".show()
	$"../../Hitbox/CollisionShape2D".set_deferred("disabled", false)
	$"../../Hitbox/CollisionShape2D2".set_deferred("disabled", false)
	$"../../AnimationPlayer".play("Drill")
	get_parent().velocity.y = POP_UP_SPEED

func _update(delta):
	owner.move_and_slide(get_parent().velocity,Vector2.UP)
	get_parent().velocity.y = clamp(get_parent().velocity.y + Physics.GRAVITY_WATER,-Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	if get_parent().velocity.y > 0.0:
		emit_signal("finished", "turnaround")
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
