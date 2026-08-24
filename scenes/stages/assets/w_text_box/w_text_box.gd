extends CanvasLayer

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const typing_label = preload("res://scenes/menus/menu-controls/TypingLabel.tscn")
#-------------------------------------------------
#      Signals\
#-------------------------------------------------
signal text_box_shown
signal text_box_dismissed
signal label_complete
#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var textbox = $TextBoxScreenContainer
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass
func _physics_process(delta):
	pass
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func start():
	var t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_ELASTIC)
	t.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(textbox,"rect_position",Vector2(textbox.rect_position.x, textbox.rect_position.y + 66), 1.0)
	yield(t,"finished")
	emit_signal("text_box_shown")

func end():
	var t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_ELASTIC)
	t.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(textbox,"rect_position",Vector2(textbox.rect_position.x, textbox.rect_position.y - 66), 1.0)
	yield(t,"finished")
	emit_signal("text_box_dismissed")

func add_label(label:Label):
	label.rect_min_size = Vector2(239,47)
	$TextBoxScreenContainer/TextBox/TextBoxLabelContainer.add_child(label)
	label.start()
	yield(label, "label_complete")
	$TextBoxScreenContainer/TextBox/TextBoxLabelContainer.remove_child(label)
	emit_signal("label_complete")
	label.queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
