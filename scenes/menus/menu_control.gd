extends Control

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal fade_in
signal fade_out
#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT,SceneTree.STRETCH_ASPECT_KEEP,Vector2(256,224),1.0)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func fade_in():
	$Tween.interpolate_property($ColorRect,"modulate",Color(1,1,1,1), Color(1,1,1,0),Physics.MENU_FADE_TIME,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	emit_signal("fade_in")
	
func fade_out():
	$Tween.interpolate_property($ColorRect,"modulate",Color(1,1,1,0), Color(1,1,1,1),Physics.MENU_FADE_TIME,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	emit_signal("fade_out")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

