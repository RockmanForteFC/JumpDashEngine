extends Node2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var frame = 0
var selected:Vector2 = Vector2.ZERO
var slots = {
		"1": null,
		"2": null,
		"3": null,
		"4": null,
		"5": null,
		"6": null,
		"7": null,
		"8": null
	}
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Timer.connect("timeout",self,"_on_timeout")
	initialize_weapon_wheel()
	set_physics_process(Config.weapon_wheel_enabled)
	Physics.attach_ui_to_player(self)
	if not Config.weapon_wheel_enabled:
		hide()

func _physics_process(delta):
	if not Config.weapon_wheel_enabled:
		return
	if frame == 4:
		frame = 0
		if PlayerValues.player and !PlayerValues.player.prevent_swaps:
			if Input.is_action_pressed("action_right_analog_down"):
				selected += Vector2.DOWN
				appear()
			if Input.is_action_pressed("action_right_analog_right"):
				selected += Vector2.RIGHT
				appear()
			if Input.is_action_pressed("action_right_analog_left"):
				selected += Vector2.LEFT
				appear()
			if Input.is_action_pressed("action_right_analog_up"):
				selected += Vector2.UP
				appear()
			if selected != Vector2.ZERO:
				set_all_to_grey()
				
				if selected == (Vector2.LEFT + Vector2.UP):
					$slot_1.material.set_shader_param("is_sold_out", false)
					change_weapon(slots["1"])
				elif selected == (Vector2.UP):
					$slot_2.material.set_shader_param("is_sold_out", false)
					change_weapon(slots["2"])
				elif selected == (Vector2.RIGHT + Vector2.UP):
					$slot_3.material.set_shader_param("is_sold_out", false)
					change_weapon(slots["3"])
				elif selected == (Vector2.RIGHT):
					$slot_4.material.set_shader_param("is_sold_out", false)
					change_weapon(slots["4"])
				elif selected == (Vector2.RIGHT + Vector2.DOWN):
					$slot_5.material.set_shader_param("is_sold_out", false)
					change_weapon(slots["5"])
				elif selected == (Vector2.DOWN):
					$slot_6.material.set_shader_param("is_sold_out", false)
					change_weapon(slots["6"])
				elif selected == (Vector2.LEFT + Vector2.DOWN):
					$slot_7.material.set_shader_param("is_sold_out", false)
					change_weapon(slots["7"])
				elif selected == (Vector2.LEFT):
					$slot_8.material.set_shader_param("is_sold_out", false)
					change_weapon(slots["8"])
				selected = Vector2.ZERO
	else:
		frame += 1

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func set_all_to_grey():
	for i in 8:
		get_node("slot_"+str(i+1)).material.set_shader_param("is_sold_out", true)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func initialize_weapon_wheel():
	slots = {
		"1": null,
		"2": null,
		"3": null,
		"4": null,
		"5": null,
		"6": null,
		"7": null,
		"8": null
	}
	var index = 0
	var slot_number = 1
	for weapon in PlayerValues.obtained_weapons.values():
		if index == 0:
			index += 1
			continue
		if weapon != null:
			slots[str(slot_number)] = weapon
			var t = AtlasTexture.new()
			t.atlas = load(weapon.icon)
			t.region = Rect2(0,0,16,16)
			get_node("slot_" + str(slot_number)).texture = t
		slot_number += 1
				
	
func change_weapon(slot):
	if slot:
		if PlayerValues.player.get_current_weapon_name() == slot.full_name:
			return
		else:
			$swap_sound.play()
			PlayerValues.player.change_weapon("weapon_" + slot.key_name)
		
func appear():
	if not Config.weapon_wheel_enabled:
		return
	show()
	$Timer.start()
	
func _on_timeout():
	hide()
	
#-------------------------------------------------
#      Connections
#-------------------------------------------------
