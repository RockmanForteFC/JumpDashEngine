extends KinematicBody2D
#warning-ignore-all:return_value_discarded
#warning-ignore-all:unused_signal
class_name Player

const DAMAGE_NUMBER = preload("res://scenes/common/damage_numbers/damage_numbers.tscn")
const ABSORB = preload("res://scenes/players/Mega Man/animations/absorb.tscn")
const SHOULD_SOFT_STUN_METHOD: String = "_should_soft_stun"
const SOFT_STUN_METHOD: String = "_soft_stun"
const ICE_SPEED_MULTIPLIER:float = 1.4
#-------------------------------------------------
#     Properties
#-------------------------------------------------

export(int, 1, 2) var player_number := 1
#export(bool) var can_double_jump := false
export(float, 1.0, 4.0) var damage_multiplier:float = 1.0
export(float, 1.0, 4.0) var knock_back_multiplier:float = 1.0
export(int, 1, 10) var max_on_screen_projectiles := 3

var hit_points: int

var is_invincible := false
var has_invulnerability_shield:bool = false
var has_i_frames := false
var is_dead := false
var is_climbing := false
var is_sliding := false
var was_previously_in_slide := false
var is_still := false
var moving_duration:float = 0
var is_feet_locked:= false
var is_climb_locked:= false
var is_bouncing := false
var is_climbing_disabled = false
var has_maelstrom_boost:bool = false
var is_in_water:bool = false
var is_in_space:bool = false
var is_in_high_gravity:bool = false
var is_speed_boosted:bool = false
var is_red_bulled:bool = false
var is_in_mid_charge:bool = false
var is_in_cold_environment:bool = false
var has_low_friction:bool = false
var keep_momentum:bool = false
var is_caught:bool = false
var is_ready_frame_for_trail:bool = true
var boss_door_transition:bool = false
var is_upside_down:bool = false setget _set_is_upside_down
var prevent_swaps:bool = false
var number_of_in_contact_water:int = 0
var snap = Vector2.DOWN * 3 setget ,_get_snap
var is_charge_locked:bool = false
var explode_on_death := true
var ladder: StaticBody2D
var gravity_direction: Vector2 = Vector2.DOWN

var gravity: float setget , _get_player_gravity
var walking_speed:float setget, _get_player_walking_speed
var climb_speed:float setget, _get_player_climbing_speed

var charge_duration: float = 0
var charge_level: int setget , _get_charge_level

#this keeps your charge while you dont press shoot. for example taking damage. you will shoot as soon as your knockback is finished. unless you're still holding shoot
var buffering_charge: bool = false

var caught_mode:String = ""
var has_in_air_jump: bool = true
var input_controller: int
var on_clear_velocity:Vector2 = Vector2.ZERO
var state_machine_lockdown:bool = false
var touched_tp:bool = false
var is_forced_fall:bool = false
onready var stopper_ray_cast: RayCast2D = $CollisionShape2D/StopperRayCast
onready var _ray_cast: RayCast2D = $CollisionShape2D/RayCast2D
onready var _charge_sound: AudioStreamPlayer = $Audio/ChargeWeapon
onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _iframes: AnimationPlayer = $InvincibilityFrames
onready var _sprite: Sprite = $Sprite

#used for ladder shooting
var last_shooting_direction:Vector2
var intro_velocity := Vector2.ZERO
#-------------------------------------------------s
#      Signals
#-------------------------------------------------

signal change_state(state_name)
signal hit_points_changed(hit_points)
signal weapon_energy_changed(weapon_energy)
signal weapon_changed(weapon_energy, new_color)
signal died()
signal death_freeze_finished()
signal exited()
signal player_ready()
signal ready_to_move()
signal serenade_note()
signal take_damage()
signal weapon_changed_swap()
#signal for challenges
signal action(name)
signal reinit()
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	$Sprite.hide()
	dont_accept_inputs()
	set_physics_process(false)

func _process(delta):
	intro_velocity.y = clamp(intro_velocity.y + Physics.GRAVITY,-Physics.FALL_SPEED_MAX,Physics.FALL_SPEED_MAX)
	move_and_slide_with_snap(intro_velocity , self.snap, -self.gravity_direction)
	if is_on_floor():
		intro_velocity = Vector2.ZERO
		set_process(false)

func _physics_process(delta):
	on_clear_velocity.y = clamp(on_clear_velocity.y + Physics.GRAVITY_WATER, -Physics.FALL_SPEED_MAX_IN_WATER, Physics.FALL_SPEED_MAX_IN_WATER)
	move_and_slide(on_clear_velocity, -self.gravity_direction)
	if is_on_floor():
		on_clear_velocity.y = 0
		_animation_player.play("Idle")


#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func is_ready_to_teleport():
	return !PlayerValues.is_teleporting and $Sprite.visible and !is_feet_locked and is_on_floor()

func lock_feet():
	is_feet_locked = true

func unlock_feet():
	is_feet_locked = false

func pause_feet():
	if is_on_floor():
		is_feet_locked = true
		$StandShootTimer.stop()
		$StandShootTimer.start()

func stop_player_process():
	$StateMachine.active = false

func start_player_process():
	$StateMachine.active = true

func set_facing_direction(value: Vector2) -> void:
	if value == Vector2.RIGHT:
		$Sprite.flip_h = false
	elif value == Vector2.LEFT:
		$Sprite.flip_h = true

func get_facing_direction() -> Vector2:
	return Vector2.LEFT if $Sprite.flip_h else Vector2.RIGHT

func play_special_animation(anim_name: String) -> void:
	is_in_mid_charge = true
	$charging.play(anim_name)
	$charging.show()

func stop_special_animation() -> void:
	is_in_mid_charge = false
	$charging.play("stop")
	$charging.hide()

func reset_color() -> void:
	$Sprite.use_parent_material = true

func charge_weapon(weapon_energy: int, ignore_energy_balancer:bool = false) -> void:
	if $Weapons.current_state.has_method("charge_energy"):
		$Weapons.current_state.charge_energy(weapon_energy, ignore_energy_balancer)


func reinit_state_map():
	$Weapons.reinit_state_map()
	emit_signal("reinit")


func set_reverse_gravity(is_reverse:bool):
	if is_reverse:
		self.is_upside_down = true
		scale.y = -1
	else:
		self.is_upside_down = false
		scale.y = 1

func change_weapon(weapon_name: String) -> void:
	$Weapons.change_weapon(weapon_name)

func default_to_buster():
	$Weapons.change_weapon("weapon_" + PlayerValues.obtained_weapons[PlayerValues.BUSTER_SLOT].key_name)

func get_weapons_info() -> Dictionary:
	return $Weapons.get_weapons_info()

func get_current_weapon_name() -> String:
	return $Weapons.current_state.weapon_name

func climb(correction_distance: Vector2) -> void:
	if !is_climbing_disabled:
		move_and_collide(correction_distance)
		emit_signal("change_state", "climb")

func stop_climb() -> void:
	if is_climbing:
		emit_signal("change_state", "idle")

# This Function seems useless at first. But for ladder climbing it will set your direction each ladder rung so if you tap climb you wont animate.
func toggle_flip_h() -> void:
	$Sprite.flip_h = !$Sprite.flip_h

func tick_damage(life_energy:int) ->void:
	if (!has_i_frames and !has_invulnerability_shield) and !is_dead:
		PlayerValues.sub_health(life_energy)
		hit_points = PlayerValues.health
		if Config.show_damage_values:
			var damage_number = DAMAGE_NUMBER.instance()
			damage_number.damage = str(life_energy)
			damage_number.position = position
			get_parent().add_child(damage_number)
		if hit_points < 1:
			explode_on_death = true
			die()
		else:
			emit_signal("hit_points_changed", hit_points)

func get_buster():
	return get_node("MegaBusterPos")

func take_damage(life_energy:int) -> void:
	PlayerValues.sub_health(life_energy)
	hit_points = PlayerValues.health
	if Config.show_damage_values:
		var damage_number = DAMAGE_NUMBER.instance()
		damage_number.damage = str(life_energy)
		damage_number.position = position
		get_parent().add_child(damage_number)
	emit_signal("action","take_damage")
	if hit_points < 1:
		explode_on_death = true
		die()
	else:
		_hurt()
		emit_signal("hit_points_changed", hit_points)

func heal(life_energy: int) -> void:
	PlayerValues.add_health(life_energy)
	hit_points = PlayerValues.health
	emit_signal("hit_points_changed", hit_points)

func swap_color(main: Color, secondary: Color) -> void:
	$Sprite.material.set_shader_param("replace_0", main)
	$Sprite.material.set_shader_param("replace_1", secondary)
	$Sprite.use_parent_material = false

func proto_whistle_pause_on():
	Physics.is_pause_enabled = false
	Physics.is_in_pausible_state = false
	_stop_moving()
	dont_accept_inputs()

func proto_whistle_pause_off():
	Physics.is_pause_enabled = true
	Physics.is_in_pausible_state = true
	_start_moving()
	accept_inputs()

func hard_knuckle_pause_on():
	Physics.is_pause_enabled = false
	Physics.is_in_pausible_state = false
	_stop_moving()
	dont_accept_inputs()

func hard_knuckle_pause_off():
	Physics.is_pause_enabled = true
	Physics.is_in_pausible_state = true
	_start_moving()
	accept_inputs()

func dont_accept_inputs():
	is_charge_locked = true
	is_feet_locked = true
#	$Inputs.controller = 0
	prevent_swaps = true
	#$StateMachine.locked = true

func accept_inputs():
	is_feet_locked = false
#	$Inputs.controller = player_number
	prevent_swaps = false
	is_charge_locked = false
	#$StateMachine.locked = false

func die():
	if !is_dead:
		PlayerValues.die()
		dont_accept_inputs()
		get_tree().call_group("ProtoWhistleP1","queue_free")
		emit_signal("hit_points_changed", 0)
		emit_signal("change_state", "death")
		if PlayerValues.game_mode != "main" and (PlayerValues.game_mode != "endless" and PlayerValues.game_mode != "challenge" and PlayerValues.game_mode != "time_trial"):
			PlayerValues.game_mode = "main"
#		yield(Config,"http_request_done")
		emit_signal("died")
		Physics.is_in_pausible_state = false
		boss_door_transition = false
		Physics.current_stage.get_node("UI/MarginContainer/HealthBar/BossBar").hide()
		if Physics.current_stage.get_node_or_null("UI/MarginContainer/HealthBar/BossBar2") != null:
			Physics.current_stage.get_node("UI/MarginContainer/HealthBar/BossBar2").hide()
		set_physics_process(false)

func _register_foot_step():
	pass

func _register_sneeze():
	pass

func show_sprite():
	$Sprite.show()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _get_charge_level() -> int:
	var level: int = 0
	if charge_duration > Physics.CHARGE_DURATION_LVL1:
		level += 1
	if charge_duration > Physics.CHARGE_DURATION_LVL2:
		level += 1
	if PlayerValues.can_max_charge and charge_duration > Physics.CHARGE_DURATION_LVL3:
		level += 1

	return level

func _shoot_offset():
	$Sprite.position.x = (4 * get_facing_direction().x)

func _set_is_upside_down(val: bool) -> void:
	is_upside_down = val
	gravity_direction = (2.0 * float(!is_upside_down) - 1.0) * Vector2.DOWN

func _get_snap() -> Vector2:
	return snap.abs() * self.gravity_direction

func _get_player_gravity()->float:
	var grav = Physics.GRAVITY
	if has_maelstrom_boost:
		grav = Physics.GRAVITY_MAELSTROM
	if is_in_water:
		grav = Physics.GRAVITY_WATER
	if is_in_space:
		grav = Physics.GRAVITY_SPACE
	if is_in_high_gravity:
		grav = Physics.GRAVITY_HIGH
	if is_upside_down:
		grav = -grav
	return grav

func _get_player_walking_speed()->float:
	if is_speed_boosted:
		return Physics.WALKING_SPEED + Physics.SPEED_BOOST
	return Physics.WALKING_SPEED

func _get_player_climbing_speed()->float:
	if is_speed_boosted:
		return Physics.CLIMB_SPEED + (Physics.SPEED_BOOST/2)
	return Physics.CLIMB_SPEED

func _hurt() -> void:
	var state_machine: StateMachine = $StateMachine
	var current_state: State = state_machine.current_state
	if \
			is_instance_valid(current_state) and \
			current_state.has_method(SHOULD_SOFT_STUN_METHOD) and \
			current_state.call(SHOULD_SOFT_STUN_METHOD) == true:
		var hurt_state: State = state_machine.states_map["hurt"]
		if hurt_state.has_method(SOFT_STUN_METHOD):
			hurt_state.call(SOFT_STUN_METHOD)
			return
	emit_signal("change_state", "hurt")

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_ready() -> void:
	set_collision_mask_bit(Bitmask.land_gimick, true)
	$Animation_Teleport_In.ready_text()
	PlayerValues.refill_all_health()
	$StateMachine.initialize($StateMachine.start_state)
	Physics.is_in_boss_fight = false
	$Sprite.hide()
	#Pause becomes available once you touch the ground
	yield(get_tree().create_timer(2),"timeout")
	Physics.is_in_pausible_state = true
	accept_inputs()
	is_dead = false
	explode_on_death = true

func on_restarted():
	has_i_frames = false
	has_invulnerability_shield = false
	$AnimationPlayer.play("Nothing")
	show()
	boss_door_transition = false
	emit_signal("player_ready")
	number_of_in_contact_water = 0
	is_in_water = false
	set_physics_process(false)

func on_iframes_expire() -> void:
	has_i_frames = false

func on_rush_coil() ->void:
	emit_signal("change_state", "high-bounce")

func on_bomb_boost() ->void:
	emit_signal("change_state","bomb-boost")

func on_spring_bounce() -> void:
	emit_signal("change_state", "spring-bounce")

func stun():
	emit_signal("change_state", "stun")

func fall():
	emit_signal("change_state", "fall")

func _on_teleport_show_player():
	$Sprite.show()

func _on_Animation_Teleport_In_on_teleport_in_complete():
	$Sprite.show()
	Physics.is_pause_enabled = true
	Physics.is_in_pausible_state = true
	if not is_connected("change_state", $StateMachine, "_change_state"):
		var _conneced = connect("change_state", $StateMachine, "_change_state")
	emit_signal("change_state","idle")
	$Inputs.controller = player_number
	emit_signal("ready_to_move")

#on section transions we want megaman to continue doing the animation they were doing
func on_camera_transition_start() -> void:
	_animation_player.pause_mode = PAUSE_MODE_PROCESS
	if is_climbing:
		_animation_player.play("Climb")
	elif _animation_player.current_animation == "idle":
		emit_signal("change_state", "move")
		_animation_player.play("Move")

func on_camera_transition_end() -> void:
	_animation_player.pause_mode = PAUSE_MODE_INHERIT
	# Interrupt jumping after the transition if player does not hold jump button
	var state_machine: StateMachine = $StateMachine
	var current_state: State = state_machine.current_state
	if \
			current_state == state_machine.states_map["jump"] and \
			sign(current_state.velocity.y) == -sign(self.gravity_direction.y) and \
			not current_state.inputs.is_action_pressed(InputHandler.Action.JUMP):
		current_state.velocity.y = 0.0

func on_hit(damage: int, damage_type:int,element_type:int) -> void:
	if (not has_i_frames and !has_invulnerability_shield) and not is_dead and not PlayerValues.is_teleporting:
		has_i_frames = true
		Score.change(Score.CONTACT_DAMAGE if damage_type == Physics.Damage.contact else Score.PROJECTILE_DAMAGE)
		take_damage(floor(damage * damage_multiplier))
		if not is_dead or !is_caught:
			emit_signal("take_damage")
			_hurt()

func on_spike() -> void:
	if (not has_i_frames and !has_invulnerability_shield):
		if !is_dead:
			if (Config.die_on_spikes and PlayerValues.shock_absorber_inventory_count == 0) or PlayerValues.is_in_special_game_mode:
				explode_on_death = true
				PlayerValues.sub_health(99)
				hit_points = PlayerValues.health
				die()
				Score.change(Score.DEATH_BY_SPIKE)
			else:
				if not Config.die_on_spikes or PlayerValues.shock_absorber_inventory_count > 0:
					PlayerValues.shock_absorber_inventory_count -= 1
				on_hit(Physics.DAMAGE_ON_SPIKES_WHEN_PLAYER_HAS_PROTECTION,Physics.Damage.spike, Physics.Element.neutral)
	else:
		if !PlayerValues.is_teleporting and !PlayerValues.player.has_invulnerability_shield:
			Score.change(Score.DAMAGE_BOOST_INSTANT_DEATH)

func on_spike_forced_death() -> void:
	if !is_dead:
		explode_on_death = true
		PlayerValues.sub_health(99)
		hit_points = PlayerValues.health
		die()
		Score.change(Score.DEATH_BY_SPIKE)

func on_laser():
	if (not has_i_frames and !has_invulnerability_shield):
		if !is_dead:
			explode_on_death = true
			PlayerValues.sub_health(99)
			hit_points = PlayerValues.health
			die()
			Score.change(Score.DEATH_BY_LASER)
	else:
		if !has_invulnerability_shield:
			Score.change(Score.DAMAGE_BOOST_INSTANT_DEATH)

func in_pit() -> void:
	if !is_dead:
		owner.play_death_sound()
		explode_on_death = false
		PlayerValues.sub_health(99)
		hit_points = PlayerValues.health
		die()
		Score.change(Score.DEATH_BY_PIT)

func on_lava() -> void:
	if not is_dead and !has_invulnerability_shield:
		explode_on_death = true
		PlayerValues.sub_health(99)
		hit_points = PlayerValues.health
		die()
		Score.change(Score.DEATH_BY_LAVA)


func on_acid() ->void:
	on_spike()

func on_crush() ->void:
	if not is_dead:
		set_collision_mask_bit(Bitmask.land_gimick, false)
		explode_on_death = true
		PlayerValues.sub_health(99)
		hit_points = PlayerValues.health
		die()
		Score.change(Score.DEATH_BY_CRUSH)

func on_out_of_bounds()->void:
	if not is_dead:
		set_collision_mask_bit(Bitmask.land_gimick, false)
		explode_on_death = true
		PlayerValues.sub_health(99)
		hit_points = PlayerValues.health
		die()
		Score.change(Score.DEATH)

func on_boss_entered() -> void:
	fall()

func on_boss_ready_to_begin()->void:
	pass

func on_boss_died() -> void:
	is_invincible = true
	#$Inputs.controller = InputHandler.Controller.EMPTY

func on_stage_cleared() -> void:
	if is_on_floor():
		emit_signal("change_state", "idle")
	else:
		emit_signal("change_state", "jump")
	state_machine_lockdown = true
	yield(get_tree().create_timer(1.0),"timeout")
	#$"Cutscenes/StageClear".start()

func _on_orb_collected()->void:
	has_invulnerability_shield = true
	if is_on_floor():
		emit_signal("change_state", "idle")
	else:
		emit_signal("change_state", "jump")
	state_machine_lockdown = true

func on_level_end() ->void:
	$StateMachine.active = false
	on_clear_velocity.y -= 240
	_animation_player.play("Jump")
	set_physics_process(true)
	yield(get_tree().create_timer(0.8),"timeout")
	set_physics_process(false)
	_animation_player.play("Jump")
	var absorb = ABSORB.instance()
	absorb.posx = global_position.x
	absorb.posy = global_position.y
	get_parent().call_deferred("add_child",absorb)
	yield(get_tree().create_timer(3.0), "timeout")
	_animation_player.play("Jump")
	set_physics_process(true)
	yield(get_tree().create_timer(1.3),"timeout")
	set_physics_process(false)
	_animation_player.play("Fanfare")
	yield(_animation_player,"animation_finished")
	$Sprite.hide()
	$TeleportOut.teleport()

func on_fortress_boss_stage_end():
	$StateMachine.active = false
	_animation_player.play("Fanfare")
	yield(_animation_player,"animation_finished")
	$Sprite.hide()
	$TeleportOut.teleport()

func on_boss_clear_begin_cutscene() ->void:
	$StateMachine.active = false

func on_boss_clear_final_cutscene() ->void:
	$StateMachine.active = false
	_animation_player.play("Fanfare")
	yield(_animation_player,"animation_finished")

func _teleport_out():
	$Sprite.hide()
	$TeleportOut.teleport()

func _on_teleport_out_leave_level():
	emit_signal("exited")
	pass # Replace with function body.

func _stop_moving():
	is_climbing_disabled = true
	emit_signal("change_state","do_nothing")

func _start_moving():
	is_climbing_disabled = false
	emit_signal("change_state", "idle")

func _on_beam_exit():
	is_climbing_disabled = false
	emit_signal("change_state", "beam-boost")

func _start_flying(direction:Vector2):
	is_climbing_disabled = true
	if direction == Vector2.UP or direction == Vector2.DOWN:
		emit_signal("change_state","fly_up")
	elif direction == Vector2.LEFT or Vector2.RIGHT:
		if direction == Vector2.LEFT:
			set_facing_direction(Vector2.LEFT)
		elif direction == Vector2.RIGHT:
			set_facing_direction(Vector2.RIGHT)
		emit_signal("change_state","fly_side")

func _get_caught(mode:String = ""):
	is_caught = true
	caught_mode = mode
	if mode == "crab":
		emit_signal("change_state","crab_caught")
	else:
		emit_signal("change_state","caught")
#	emit_signal("change_state","do_nothing")

func _get_thrown(direction:Vector2):
	set_facing_direction(direction)
	emit_signal("change_state","thrown")

func is_caught_animation()->bool:
	return is_caught

func _get_released():
	if is_caught:
		is_caught = false
		emit_signal("change_state", "idle")

func _get_released_bounce():
	if is_caught:
		is_caught = false
		emit_signal("change_state", "beam-boost")

func is_on_crushable_state()->bool:
	return is_sliding or is_on_floor() or is_still

func _on_TrailFrameTimer_timeout():
	is_ready_frame_for_trail = true

func on_challenge_end():
	if !is_dead:
		$StateMachine.active = false
		_animation_player.play("Challenge_Fanfare")
		yield(_animation_player,"animation_finished")
		$Audio/TeleportOut.play()
		emit_signal("exited")
		_animation_player.play("Teleport_Small")
		yield(_animation_player,"animation_finished")
		hide()

func on_time_trial_end():
	if !is_dead:
		$StateMachine.active = false
		_animation_player.play("Challenge_Fanfare")
		yield(_animation_player,"animation_finished")
		$Audio/TeleportOut.play()
		emit_signal("exited")
		_animation_player.play("Teleport_Small")
		yield(_animation_player,"animation_finished")
		hide()

func on_teleporter_out():
	$Audio/TeleportOut.play()
	_animation_player.play("Teleport_Small")
	yield(_animation_player,"animation_finished")
	hide()

func on_teleporter_in():
	show()
	if $Audio/TeleportOut.playing:
		$Audio/TeleportOut.stop()
	$Audio/Teleport.play()
	_animation_player.play("Teleport_Small_Reversed")
	yield(_animation_player,"animation_finished")
	_animation_player.play("Idle")

func reinitialize_collision():
	$CollisionShape2D.disabled = true
	yield(get_tree().create_timer(0.01),"timeout")
	$CollisionShape2D.disabled = false

func get_behind_hover_location():
	return $behind_player_hover.global_position

func can_handle_action(with_charge_lock: bool = true) -> bool:
	return not state_machine_lockdown and (!with_charge_lock or !is_charge_locked)

func _on_StandShootTimer_timeout():
	is_feet_locked = false
	$StandShootTimer.stop()

func _cancel_charge() -> void:
	charge_duration = 0.0
	_charge_sound.stop()
	stop_special_animation()
