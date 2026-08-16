extends Control

func _ready():
#	$Labels/MenuContainer.hide()
	yield(get_tree().create_timer(0.3),"timeout")
	$Tween.interpolate_property($ColorRect,"modulate",Color(1,1,1,1), Color(1,1,1,0),Physics.MENU_FADE_TIME,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	$pulse_tween.interpolate_property($BlackBG2,"material:shader_param/outerRadius",0.001,0.396,3.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,0.75)
	$pulse_tween.interpolate_property($BlackBG2,"material:shader_param/outerRadius",0.396,0.001,3.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,3.50)
	$pulse_tween.start()
	yield($Tween,"tween_all_completed")

	$Audio/BackgroundMusic.play()
	$Labels/MenuContainer.hide()
	$Labels/Version.text = ProjectSettings.get_setting("application/config/version") if ProjectSettings.get_setting("application/config/version") != "" else "0.0.0"
	$Sprites/megaman_title_text.play("fade_in")

	$Labels/Version.show()
	$Labels/Year.show()
	$Labels/MenuContainer.is_active = true
	$Labels/MenuContainer.show()

func _on_MenuContainer_menu_item_selected(selectedMenuOption):
	$Labels/MenuContainer.is_active = false
	$Tween.interpolate_property($ColorRect,"modulate",Color(1,1,1,0), Color(1,1,1,1),Physics.MENU_FADE_TIME,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	if "start" in selectedMenuOption.to_lower():
		Handle_Start()
	if "config" in selectedMenuOption.to_lower():
		Handle_Config()
	if "quit" in selectedMenuOption.to_lower():
		Handle_Quit()

func Handle_Start():
	return get_tree().change_scene("res://scenes/menus/main_menu/main_menu.tscn")

func Handle_Config():
	return get_tree().change_scene("res://scenes/menus/config/config_options.tscn")

func Handle_Quit():
	Config.save_config()
	get_tree().quit()
