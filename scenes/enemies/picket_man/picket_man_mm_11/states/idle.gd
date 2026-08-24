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

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter():
	$"../../EnemyAnimations".play("Idle")
	$"../../AttackTimer".start()

func _update(delta):
	get_parent().velocity.y = \
	clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor():
		get_parent().velocity = Vector2.ZERO
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_timer_timeout():
	emit_signal("finished", "attack")
