extends "megaman_common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _enter():
	owner.is_forced_fall = true
	velocity.y = 0
	$"../../AnimationPlayer".play("Jump")

func _update(delta):
	if !owner.is_dead:
		var fall_speed = Physics.FALL_SPEED_MAX
		velocity.y = clamp(velocity.y + owner.gravity, -fall_speed, fall_speed)
		owner.move_and_slide_with_snap(Vector2(0,velocity.y), owner.snap, -owner.gravity_direction)
		if owner.is_on_floor():
			back_to_idle()

func _exit():
	owner.is_forced_fall = false

func _handle_command(command: String) -> void:
	._handle_command(command)
	if command.begins_with("weapon_"):
		weapons.change_weapon(command)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func back_to_idle():
	emit_signal("finished","idle")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
