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

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter() -> void:
	owner.is_blocking = true
	$"../../EnemyAnimations".play("Idle")

func _update(delta: float) -> void:
	get_parent().velocity.y = \
		clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor():
		get_parent().velocity = Vector2.ZERO
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_Timer_timeout() -> void:
	if _trigger_area.player:
		# Change facing direction if necessary
		var vector_to_player: Vector2 = _trigger_area.player.global_position - $"../../Hitbox".global_position
		if sign(owner.get_facing_direction().x) != sign(vector_to_player.x):
			owner.toggle_flip_h()

		emit_signal("finished", "shoot")
	else:
		_trigger_area.is_shot_ready = true
