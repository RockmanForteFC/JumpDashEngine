extends "common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var _timer_idle_delay: Timer = $"../../TimerIdleDelay"
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready() -> void:
	_timer_idle_delay.connect("timeout", self, "_on_timeout")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
# every time you switch to idle there is a wait of x.xx seconds before an action is performed
func _enter() -> void:
	owner.face_player()
	animated_sprite.play("Idle")
	_timer_idle_delay.start()

func _update(delta: float) -> void:
	#if not on ground. move down until ground is reached.
	owner.move_and_slide(Vector2.DOWN * Physics.GRAVITY, Vector2.UP)
#-------------------------------------------------
#      Connections
#-------------------------------------------------
#here is the magic. when a timeout on the "Idle Delay" is done, perform your logic here.
func _on_timeout() -> void:
		# roll a random number between 0 and 7
		var random_number: float = Physics.rng.randi_range(0, 5)
		# on 0 ,1, 2 do the following
		if random_number <= 2:
			emit_signal("finished", "shoot")
		else:
			# jump is in the common.gd for wave man
			# statemachine/jump has a connection attack to perform water_wave
			jump()
