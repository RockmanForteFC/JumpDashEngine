extends Control
#warning-ignore-all:return_value_discarded
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const TRANSPARENT := Color("00ffffff")
const OPAQUE := Color("ffffffff")
#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal screen_faded_in()
signal screen_faded_out()
#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var _tween: Tween = $Tween
onready var _black_screen: ColorRect = $ColorRect
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready() -> void:
	hide()
	_tween.connect("tween_completed", self, "_on_tween_completed")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func fade_out(duration: float) -> void:
	_black_screen["modulate"] = TRANSPARENT
	_tween.remove_all()
	_tween.interpolate_property(_black_screen, "modulate", TRANSPARENT, OPAQUE, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	show()
	_tween.start()


func fade_in(duration: float) -> void:
	_black_screen["modulate"] = OPAQUE
	_tween.remove_all()
	_tween.interpolate_property(_black_screen, "modulate", OPAQUE, TRANSPARENT, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	show()
	_tween.start()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_tween_completed(object: Object, _key: String) -> void:
	if object["modulate"] == OPAQUE:
		emit_signal("screen_faded_out")
	else:
		emit_signal("screen_faded_in")
