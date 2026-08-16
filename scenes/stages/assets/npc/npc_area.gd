extends Area2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var show_up_queue:bool = false
var show_dialog:bool = false
export(String,MULTILINE) var dialogText = "this is a dialog box"
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	$CanvasLayer/TextBoxScreenContainer/TextBox/TextBoxLabelContainer/TextBody.text = dialogText

func _process(delta):
	if show_up_queue and not Physics.is_game_paused:
		
		if Input.is_action_just_pressed("action_up_p1") and not show_dialog:
			get_tree().paused = true
			_open_dialog()
		
		if (Input.is_action_just_pressed("action_jump_p1") \
				or Input.is_action_just_pressed("action_shoot_p1")
				or Input.is_action_just_pressed("action_enter_p1")) and show_dialog:
			_close_dialog()
			get_tree().paused = false
			
	if Physics.is_game_paused and show_dialog:
		_close_dialog()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _open_dialog():
	get_parent().play("Active")
	$Audio/Open.play()
	$CanvasLayer.show()
	yield(get_tree().create_timer(0.05),"timeout")
	var tween = create_tween()
	Physics.is_in_pausible_state = false
	tween.tween_property($CanvasLayer,"offset",Vector2(0,0),0.25)
	show_dialog = true
	
func _close_dialog():
	get_parent().play("Idle")
	$Audio/Close.play()
	var tween = create_tween()
	tween.tween_property($CanvasLayer,"offset",Vector2(0,-66),0.25)
	show_dialog = false
	yield(get_tree().create_timer(0.25),"timeout")
	$CanvasLayer.hide()
	Physics.is_in_pausible_state = true

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_NPC_body_entered(body):
	show_up_queue = true
	$UpQueue.show()

func _on_NPC_body_exited(body):
	show_up_queue = false
	$UpQueue.hide()
