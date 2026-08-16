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
var falling_frame_count:int = 0
onready var idle_timer = $"../../Timer"
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _enter():
		$"../../AnimationPlayer".play("Fall")
		idle_timer.stop()
		
func _update(delta):
	falling_frame_count += 1
	get_parent().velocity.y = \
		clamp(ceil(get_parent().velocity.y + Physics.GRAVITY), -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	
	if owner.is_on_floor():
		if falling_frame_count > 10:
			$"../../Audio/FallLanding".play()
		falling_frame_count = 0
		emit_signal("finished", "idle")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
