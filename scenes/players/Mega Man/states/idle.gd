extends "on_ground.gd"

const STILL_FRAME_COUNT: int = 4

export(Vector2) var buster_position := Vector2(17, 3)

var _frame_count: int
var was_preset:bool = false

func preset(velocity_start: Vector2) -> void:
	if velocity_start.x != 0:
		was_preset = true
		get_parent()._change_state("move")

func _enter() -> void:
	$"../../slide".set_deferred("disabled", true)
	owner.keep_momentum = false
	owner.is_bouncing = false
	animation_player.play("Idle")
	mega_buster.position = buster_position
	_frame_count = -1
	owner.was_previously_in_slide = false

func _exit():
	owner.is_feet_locked = false
	was_preset = false

func _handle_command(command: String) -> void:
	._handle_command(command)
	
	if command == "shoot":
		shoot("Idle_" + weapons.current_state.anim_name)
	if command == "hold_shoot":
		hold_shoot("Idle_" + weapons.current_state.anim_name)
	if command.begins_with("weapon_"):
		weapons.change_weapon(command)

func _update(_delta: float) -> void:
	if !owner.is_dead:
		_frame_count += 1
		if _frame_count > STILL_FRAME_COUNT:
			owner.moving_duration = 0.0
			owner.is_still = true
		
		if owner.is_still and owner.is_in_cold_environment:
			var random_number = Physics.rng.randi_range(0,600)
			if random_number == 1:
				animation_player.play("Sneeze")
		
		# To check if on floor
		owner.move_and_slide_with_snap(Vector2.DOWN * owner.gravity, owner.snap, -owner.gravity_direction)
			
		if !owner.is_on_floor():
			emit_signal("finished", "jump")
		elif get_input_direction().x != 0 and not owner.is_feet_locked:
			emit_signal("finished", "move")
	#
		if owner.charge_level > 0 and not weapons.is_holding_shoot():
			if !owner.is_charge_locked:
				_handle_command("shoot")
		
		if weapons.current_state.is_holding_shoot():
			_handle_command("hold_shoot")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name.begins_with("Idle_Shoot"):
		animation_player.play("Idle")
	if anim_name.begins_with("Idle_Hold_Shoot"):
		animation_player.play("Idle")
	if anim_name.begins_with("Idle_Kick"):
		animation_player.play("Idle")
	if anim_name.begins_with("Sneeze"):
		animation_player.play("Idle")
	if anim_name.begins_with("Idle_Flex"):
		animation_player.play("Idle")
	if anim_name.begins_with("Idle_Shoot_Alt"):
		animation_player.play("Idle")
	if anim_name.begins_with("Idle_Shoot_Alt_2"):
		animation_player.play("Idle")
	if anim_name.begins_with("Idle_Shoot_Alt_3"):
		animation_player.play("Idle")
	if anim_name.begins_with("Idle_Shoot_Alt_4"):
		animation_player.play("Idle")
	if anim_name.begins_with("Idle_Shoot_Alt_5"):
		animation_player.play("Idle")
	if anim_name.begins_with("Idle_Shoot_TV"):
		animation_player.play("Idle")
	if anim_name.begins_with("Idle_Shoot_Pistol"):
		animation_player.play("Idle")
