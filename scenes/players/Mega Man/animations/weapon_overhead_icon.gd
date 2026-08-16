extends Control
#warning-ignore-all:return_value_discarded
#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready() -> void:
	set_process(false)
	hide()
	$Timer.connect("timeout", self, "_on_timeout")

func _process(_delta: float) -> void:

	#gets player's position in the stage 
	rect_position = PlayerValues.player.get_global_transform_with_canvas().origin
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _set_texture() -> bool:
	var texture: Resource
	for w in PlayerValues.obtained_weapons.values():
		if not w == null and w.is_equipped:
			var atlas = AtlasTexture.new()
			atlas.atlas=load(w.icon)
			atlas.region = Rect2(0,0,16,16)
			texture = atlas

	if texture:
		$TextureRect.texture = texture
		return true
	else:
		return false
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_weapon_changed(_weapon_energy: int, _new_color: Color) -> void:
	if _set_texture() and not Physics.is_game_paused and not PlayerValues.player.is_dead:
		$AudioStreamPlayer.play()
		set_process(true)
		show()
		$Timer.start()

func on_weaopn_swapped():
	if _set_texture() and not Physics.is_game_paused and not PlayerValues.player.is_dead:
		$AudioStreamPlayer.play()
		set_process(true)
		show()
		$Timer.start()

func _on_timeout() -> void:
	hide()
	set_process(false)


