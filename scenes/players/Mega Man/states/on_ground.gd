extends "megaman_common.gd"

func _handle_command(command: String) -> void:
	if command == "slide" and PlayerValues.can_slide and not owner.is_feet_locked:
		emit_signal("finished", "slide")
	elif command == "jump":
		emit_signal("finished", "jump")
	else:
		._handle_command(command)
