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
onready var _trigger_area = $"../../TriggerArea"
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _enter() -> void:
	get_parent().is_top_of_water = false
	owner.is_blocking = true
	$"../../AnimationPlayer".play("idle")
	
func _update(delta: float) -> void:
	get_parent().velocity.y = \
		clamp(get_parent().velocity.y + Physics.GRAVITY_WATER, -Physics.FALL_SPEED_MAX_IN_WATER, Physics.FALL_SPEED_MAX_IN_WATER)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor():
		get_parent().velocity = Vector2.ZERO
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_Timer_timeout():
	if _trigger_area.player:
		
		owner.face_player()
			
		emit_signal("finished", "popup")
	else:
		_trigger_area.is_shot_ready = true
