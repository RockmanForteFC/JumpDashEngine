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
var velocity:Vector2
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$"../../StunTimer".connect("timeout",self, "back_to_idle")

func _enter():
	velocity.y = 0
	$"../../AnimationPlayer".play("Fall")
	$"../../StunTimer".start()

func _update(delta):
	if !owner.is_dead:
		var fall_speed = Physics.FALL_SPEED_MAX
		velocity.y = clamp(velocity.y + owner.gravity, -fall_speed, fall_speed)
		owner.move_and_slide_with_snap(velocity, owner.snap, -owner.gravity_direction)

func _exit():
	$"../../StunTimer".stop()


#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func back_to_idle():
	emit_signal("finished","idle")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
