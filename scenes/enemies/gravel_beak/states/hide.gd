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
	$"../../HideTimer".connect("timeout", self, "_open")

func _enter():
	owner.is_blocking = true
	$"../../AnimationPlayer".play("Hide")

	$"../../HideTimer".start()

func _update(delta):
	for body in  $"../../playerDetector".get_overlapping_bodies():
		if body is Player and get_parent().is_in_ready_state:
			get_parent().is_in_ready_state = false
			emit_signal("finished", "open")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _open():
	get_parent().is_in_ready_state = true
