extends Area2D
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const TOAST = preload("res://scenes/menus/toast_message/toast_message.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal checkpoint_reached()
#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(String, "Right", "Left") var direction := "Right" setget set_direction
var was_activated:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:
	get_groups()
	add_to_group("Checkpoints")
	set_direction(direction)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func disable()->void:
	was_activated = false
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_body_entered(body: KinematicBody2D) -> void:
	if body is Player:
		for cp in get_tree().get_nodes_in_group("Checkpoints"):
			if cp == self:
				continue
			else:
				cp.disable()
		if body is Player and not was_activated:
			emit_signal("checkpoint_reached")
			was_activated = true
			owner.start_pos = global_position
			owner.start_dir = Vector2.RIGHT if direction == "Right" else Vector2.LEFT

func on_viewport_entered(viewport: Viewport) -> void:
	set_deferred("monitoring", true)

func on_viewport_exited(viewport: Viewport) -> void:
	set_deferred("monitoring", false)

func set_direction(value: String) -> void:
	direction = value

