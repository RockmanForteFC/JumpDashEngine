extends VisibilityNotifier2D

class_name PreciseVisibilityNotifier2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal camera_entered()
signal camera_exited()
#-------------------------------------------------
#      Properties
#-------------------------------------------------

export(bool) var enabled := true setget set_enabled, is_enabled
export(int) var margin := 0

var _was_on_screen: bool
var _is_on_screen: bool
var _sign: int

onready var _viewport := get_viewport()
onready var _viewport_rect: Rect2
onready var _rect: Rect2
onready var _base_size: Vector2

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:
	set_enabled(enabled)
	_base_size = Config.get_base_size()
	force_visibility_update()
	_was_on_screen = is_on_screen()

func _physics_process(_delta: float) -> void:
	force_visibility_update()
	_is_on_screen = is_on_screen()

	if _was_on_screen != _is_on_screen:
		emit_signal("camera_entered" if _is_on_screen else "camera_exited")
	
	_was_on_screen = _is_on_screen
	
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func is_on_screen() -> bool:
	_sign = 1 if _was_on_screen else -1
	_viewport_rect = _viewport_rect.grow(_sign * margin)
	return _viewport_rect.intersects(_rect)

func force_visibility_update() -> void:
	_viewport_rect = Rect2(-_viewport.get_canvas_transform().origin, _base_size)
	_rect = Rect2(global_position + rect.position, rect.size)

func set_enabled(value: bool) -> void:
	enabled = value
	if !enabled and _was_on_screen:
		emit_signal("camera_exited")
	_is_on_screen = _is_on_screen and enabled
	_was_on_screen = _was_on_screen and enabled
	set_physics_process(enabled)

func is_enabled() -> bool:
	return is_physics_processing()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
