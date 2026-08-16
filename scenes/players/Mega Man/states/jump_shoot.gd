extends "jump.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(Vector2) var buster_position := Vector2(17, -4)
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
	owner.was_previously_in_slide = false
	mega_buster.position = buster_position
	velocity = _velocity_init
	_velocity_init = Vector2()
	shoot("Jump_" + weapons.current_state.anim_name)

func _handle_command(command: String) -> void:
	if command == "jump_stop" and sign(velocity.y) == -sign(owner.gravity_direction.y) and not owner.is_bouncing:
		velocity.y = 0
			
	if command == "hold_shoot":
		hold_shoot("Jump_" + weapons.current_state.anim_name)
		
	if command == "shoot":
		shoot("Jump_" + weapons.current_state.anim_name)
		
	if command.begins_with("weapon_"):
		weapons.change_weapon(command)
#-------------------------------------------------
#      Connections
#-------------------------------------------------

#warning-ignore:unused_argument
func _on_animation_finished(anim_name: String) -> void:
	emit_signal("finished", "jump")
