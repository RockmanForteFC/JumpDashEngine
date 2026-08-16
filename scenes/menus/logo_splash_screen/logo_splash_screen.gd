extends Control

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

func _ready():
	$AnimationPlayer.play("fade-in-out")

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("action_jump_p1"):
		$AnimationPlayer.play("quick-fade-out")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func Handle_Start():
	return get_tree().change_scene("res://scenes/menus/epilepsy_warning/epilepsy_warning.tscn")
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ("fade-in-out"):
		Handle_Start()
	if anim_name == ("quick-fade-out"):
		Handle_Start()
