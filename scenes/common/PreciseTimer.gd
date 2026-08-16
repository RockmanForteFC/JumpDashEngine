extends Timer

class_name PreciseTimer

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

var _timeout: float

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:
	set_process(!Engine.editor_hint and autostart and _is_in_precise_range(wait_time))

func _process(delta: float) -> void:
	if not paused:
		_timeout += delta
		if _timeout >= wait_time:
			emit_signal("timeout")
			set_process(not one_shot)
			_timeout = 0.0

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func start(time_sec: float = wait_time) -> void:
	set_process(_is_in_precise_range(time_sec))
	if is_processing():
		_timeout = 0.0
		wait_time = time_sec
	elif time_sec <= 0.0:
		emit_signal("timeout")
	else:
		.start(time_sec)

func stop() -> void:
	.stop()
	set_process(false)
	_timeout = 0.0

func is_stopped() -> bool:
	return not is_processing() and .is_stopped()

func get_time_left() -> float:
	return max(wait_time - _timeout, 0.0) if is_processing() else .get_time_left()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

static func _is_in_precise_range(time_sec: float) -> bool:
	return time_sec > 0.0 and time_sec < Physics.TIMER_WAIT_TIME_MIN_THRESHOLD

#-------------------------------------------------
#      Connections
#-------------------------------------------------
