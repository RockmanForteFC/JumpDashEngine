extends "climb.gd"
#warning-ignore:return_value_discarded

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(Vector2) var buster_position := Vector2(17, -2)
#-------------------------------------------------
#      Processes
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter() -> void:
	owner.was_previously_in_slide = false
	owner.is_climbing = true
	mega_buster.position = buster_position
	shoot("Climb_" + weapons.current_state.anim_name)

func _exit() -> void:
	owner.is_climbing = false

func _handle_command(command: String) -> void:
	if command == "shoot":
		animation_player.seek(0)
		shoot("Climb_" + weapons.current_state.anim_name)
	if command == "drop_down":
		emit_signal("finished", "jump")
	if command.begins_with("weapon_"):
		weapons.change_weapon(command)

#warning-ignore:unused_argument
func _update(delta: float) -> void:
	# collision_shape.shape.extents.y = 12
	var direction: Vector2 = get_input_direction()
	if direction.x != 0:
		owner.last_shooting_direction = direction
		update_sprite_direction(owner.last_shooting_direction)
#-------------------------------------------------
#      Connections
#-------------------------------------------------
#warning-ignore:unused_argument
func _on_animation_finished(anim_name: String) -> void:
	emit_signal("finished", "climb")
