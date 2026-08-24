extends "../menu_control.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const LOCKED_TEXT = "Locked"
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	# BGM is set to use the bus "Music" which seperates the audio channels if
	# someone wants to music the songs but still have SFX or vice versa
	$BGM/BGM.play()
	PlayerValues.player = null
	PlayerValues.last_played_level = ""
	fade_in()
	yield(self,"fade_in")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func handle_new_game():
	PlayerValues.setup_new_default_play_params()
	PlayerValues.last_played_level = "stage_select"
	get_tree().change_scene("res://scenes/menus/BossSelect.tscn")

func handle_config():
	PlayerValues.last_played_level = "new_game_menu"
	get_tree().change_scene("res://scenes/menus/config/config_options.tscn")

func handle_button_config():
	PlayerValues.last_played_level = "new_game_menu"
	get_tree().change_scene("res://scenes/menus/key_mapping/key_mapping.tscn")

func handle_quit():
	Config.save_config()
	get_tree().quit()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

# This method for using the menu using the "scenes/Common/MenuContainer object is easy to use, but
# it does not support scrolling for longer lists. to reference the object you are selecting you
# need to compare the Node's name in the node-tree
func _on_MenuContainer_menu_item_selected(selectedMenuOption):
	$GameStart.is_active = false
	fade_out()
	yield(self,"fade_out")
	if "new game" in selectedMenuOption.to_lower():
		handle_new_game()
	elif "config" in selectedMenuOption.to_lower():
		handle_config()
	elif "controller" in selectedMenuOption.to_lower():
		handle_button_config()
	elif "quit" in selectedMenuOption.to_lower():
		handle_quit()

