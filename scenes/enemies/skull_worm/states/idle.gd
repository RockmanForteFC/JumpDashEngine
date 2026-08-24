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
onready var idle_timer = $"../../Timer"
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	idle_timer.connect("timeout",self,"on_idle_timeout")
	pass

func _enter():
	$"../../AnimationPlayer".play("Idle")
	if idle_timer.is_stopped():
		idle_timer.start()
	get_parent().velocity = Vector2.ZERO

func _update(delta):
	get_parent().velocity.y = \
		clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)

	if owner.is_on_floor():
		get_parent().velocity = Vector2.ZERO
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_idle_timeout():
	idle_timer.stop()
	emit_signal("finished","squirm")
