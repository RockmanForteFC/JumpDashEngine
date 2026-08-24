extends State

#-------------------------------------------------
#     Properties
#-------------------------------------------------
const TRAIL = preload("res://scenes/players/Mega Man/animations/trail.tscn")

onready var sprite: Sprite = get_node("../../Sprite")
onready var mega_buster: Position2D = get_node("../../MegaBusterPos")
onready var animation_player: AnimationPlayer = get_node("../../AnimationPlayer")
onready var weapons: Node = get_node("../../Weapons")
onready var inputs: InputHandler = get_node("../../Inputs")

#-------------------------------------------------
#     Private Methods
#-------------------------------------------------
#warning-ignore:unused_argument
func _handle_command(command: String) -> void:
	pass

#-------------------------------------------------
#     Public Methods
#-------------------------------------------------

func get_input_direction() -> Vector2:
	return get_parent().input_direction

# Returns true if direction changed.
func update_sprite_direction(direction: Vector2) -> bool:
	var last_facing_direction = owner.get_facing_direction()
	if direction.x == 1:
		sprite.flip_h = false
		$"../../behind_player_hover".position.x = -16
	elif direction.x == -1:
		sprite.flip_h = true
		$"../../behind_player_hover".position.x = 16
	sprite.offset.x = owner.get_facing_direction().x * abs(sprite.offset.x)
	return last_facing_direction != owner.get_facing_direction()

func shoot(anim:String = "Idle_Shoot", anim_pos:float = 0.0) -> bool:
	if !owner.is_charge_locked:
		owner.buffering_charge = false
		if weapons.current_state.can_use():

			if !weapons.current_state.pause_on_floor:
				if not anim_pos == 0.0:
					var pos = animation_player.current_animation_position
					animation_player.play(anim)
					animation_player.seek(pos, true)
				else:
					animation_player.stop()
					animation_player.play(anim)
			else:
				owner.pause_feet()
#				yield(get_tree().create_timer(0.1),"timeout")
				if owner.is_feet_locked:
					if anim.substr(anim.find("_"),-1) == "_Slash":
						animation_player.play("Idle_Slash")
					elif anim.substr(anim.find("_"),-1) == "_Hold_Shoot":
						animation_player.play("Idle_Hold_Shoot")
					elif anim.substr(anim.find("_"),-1) == "_Shoot":
						animation_player.play("Idle_Shoot")
					elif anim.substr(anim.find("_"),-1) == "_Non_Shoot":
						animation_player.play("Idle_Non_Shoot")
					elif anim.substr(anim.find("_"),-1) == "_Shoot_Alt":
						animation_player.play("Idle_Shoot_Alt")
					elif anim.substr(anim.find("_"),-1) == "_Shoot_Shield":
						animation_player.play("Idle_Shoot_Shield")
					elif anim.substr(anim.find("_"),-1) == "_Shoot_TV":
						animation_player.play("Idle_Shoot_TV")
					elif anim.substr(anim.find("_"),-1) == "_Shoot_Alt_2":
						animation_player.play("Idle_Shoot_Alt_2")
					elif anim.substr(anim.find("_"),-1) == "_Shoot_Alt_3":
						animation_player.play("Idle_Shoot_Alt_3")
					elif anim.substr(anim.find("_"),-1) == "_Shoot_Alt_4":
						animation_player.play("Idle_Shoot_Alt_4")
					elif anim.substr(anim.find("_"),-1) == "_Shoot_Alt_5":
						animation_player.play("Idle_Shoot_Alt_5")
					elif anim.substr(anim.find("_"),-1) == "_Flex":
						animation_player.play("Idle_Flex")
				else:
					animation_player.play(anim)
			if weapons.current_state.weapon_name == "Mega Buster" or weapons.current_state.weapon_name == "Nothing" :
				owner.emit_signal("action","shoot")
			else:
				owner.emit_signal("action","shoot_weapon")
			weapons.current_state.use()
			weapons.emit_signal("player_shoot")
			return true
		elif !weapons.current_state.can_use() and owner.is_climbing:
			emit_signal("finished", "climb")
		return false
	else:return false

func hold_shoot(anim:String ="Idle_Shoot", anim_pos:float = 0.0) -> void:
		if not anim_pos == 0.0:
			var pos = animation_player.current_animation_position
			animation_player.play(anim)
			animation_player.seek(pos, true)
		else:
			animation_player.stop()
			animation_player.play(anim)

func _should_soft_stun() -> bool:
	return false
