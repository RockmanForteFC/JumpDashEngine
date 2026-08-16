extends "../menu_control.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const TOAST = preload("res://scenes/menus/toast_message/toast_message.tscn")
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
	PlayerValues.gameover()
	$MenuContainer.disable()
	$Audio/GameOver.play()
	fade_in()
	yield(self,"fade_in")

func _process(delta):
	pass
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func handle_retry():
	get_tree().change_scene(PlayerValues.last_played_level)

func handle_stage_select():
	get_tree().change_scene("res://scenes/menus/BossSelect.tscn")

func handle_main_menu():
	get_tree().change_scene("res://scenes/menus/Start_Screen.tscn")
	PlayerValues.session_playtime = 0.0
	PlayerValues._is_timer_running = false
	
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_GameOver_finished():

	$VolumeFade.play("Fade_In_Volume")
	$MenuFade.play("Fade_In")
	$Audio/BGM.play()
	yield(get_tree().create_timer(0.7),"timeout")
	$MenuContainer.is_active = true
	$MenuContainer.enable()
	
func on_menu_selection(selectedMenuOption):
	$MenuContainer.is_active = false
	fade_out()
	yield(self,"fade_out")
	if "retry" in selectedMenuOption.to_lower():
		handle_retry()
	if "stage" in selectedMenuOption.to_lower():
		handle_stage_select()
	if "menu" in selectedMenuOption.to_lower():
		handle_main_menu()
