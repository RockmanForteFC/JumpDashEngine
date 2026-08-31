extends Control

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const FILL_DELAY: float = 0.05
const FILL_DELAY_NON_PAUSING: float = 0.035
#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal gradual_update_complete()
signal _bar_update_complete()
#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(String) var bar_name := ""
export(Color) var color := Color("f8d878") setget set_bar_color
export(Color) var color_inside := Color("ffffff") setget set_bar_color_inside
export(bool) var horizontal := false setget set_bar_orientation
export(bool) var fill_with_sound := true

var _is_updating := false

onready var _overlay = $"TextureRect/ColorRect"
onready var _overlay_h = $"TextureRectHorizontal/ColorRect"
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	 pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func update_instant(hit_points: int) -> void:
	_set_current_hp_bar(hit_points)

func update_gradual(hit_points) -> void:
	if not Config.pause_on_health_pickup:
		_update_bar(hit_points)
		yield(self, "_bar_update_complete")
		emit_signal("gradual_update_complete")
		PlayerValues.item_queue = []
		return

	if _is_updating:
		PlayerValues.item_queue = []
		return

	Physics.is_in_pausible_state = false
	_is_updating = true
	var was_paused: bool = get_tree().paused
	get_tree().paused = true
	_update_bar(hit_points)
	yield(self, "_bar_update_complete")
	get_tree().paused = was_paused
	_is_updating = false
	emit_signal("gradual_update_complete")
	Physics.is_in_pausible_state = true
	PlayerValues.item_queue = []

func set_bar_color(value: Color) -> void:
	if has_node("TextureRect/ColorOverlay") and has_node("TextureRectHorizontal/ColorOverlay"):
		$"TextureRect/ColorOverlay".modulate = value
		$"TextureRectHorizontal/ColorOverlay".modulate = value
		color = value
func set_bar_color_inside(value: Color) -> void:
	if has_node("TextureRect/ColorOverlay_Inside") and has_node("TextureRectHorizontal/Color_Overlay_inside"):
		$"TextureRect/ColorOverlay_Inside".modulate = value
		$"TextureRectHorizontal/Color_Overlay_inside".modulate = value
		color = value
func set_bar_orientation(is_horizontal: bool) -> void:
	if has_node("TextureRectHorizontal") and has_node("TextureRect"):
		$"TextureRect".visible = !is_horizontal
		$"TextureRectHorizontal".visible = is_horizontal
		horizontal = is_horizontal
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _get_current_hp_bar() -> int:
	if horizontal:
		return int(round(PlayerValues.MAX_HEALTH - _overlay_h["rect_size"].x / 2))
	else:
		return int(round(PlayerValues.MAX_HEALTH - _overlay["rect_size"].y / 2))

func _update_bar(hit_points) -> void:
	var fill_delay: float = FILL_DELAY if  Config.pause_on_health_pickup else FILL_DELAY_NON_PAUSING
	while round(clamp(hit_points, 0, PlayerValues.MAX_HEALTH )) != round(_get_current_hp_bar()):
		if fill_with_sound:
			$FillSound.stop()
			$FillSound.stream_paused = false
			$FillSound.play()
		yield(get_tree().create_timer(fill_delay), "timeout")
		_set_current_hp_bar(_get_current_hp_bar() + int(sign(hit_points - _get_current_hp_bar())))

	$FillSound.stream_paused = true  # Part of above workaround. Should just be stop() here.
	$FillSound.call_deferred("stop")  # Ensure that audio is properly stopped as part of workaround.
	# Otherwise audio will be resumed in infinite loop when exiting the pause menu or after
	# a camera screen transition due to get_tree().paused = false.

	emit_signal("_bar_update_complete")

func _set_current_hp_bar(hit_points: int) -> void:
	var offset := clamp(2 * (PlayerValues.MAX_HEALTH  - hit_points), 0, 2 * PlayerValues.MAX_HEALTH )
	if horizontal:
		_overlay_h["rect_size"].x = offset
		_overlay_h["rect_position"].x = 2 * PlayerValues.MAX_HEALTH  - offset
	else:
		_overlay["rect_size"].y = offset

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func on_restarted() -> void:
		show()
		update_instant(PlayerValues.MAX_HEALTH )

func on_hit_points_changed(hit_points: int) -> void:
	if hit_points < _get_current_hp_bar():
		update_instant(hit_points)
	elif hit_points > _get_current_hp_bar():
		update_gradual(hit_points)

func on_weapon_changed(weapon_energy: int, new_color: Color, new_color_inside: Color) -> void:
	if new_color == Color.transparent:
		hide()
	else:
		set_bar_color(new_color)
		set_bar_color_inside(new_color_inside)
		update_instant(weapon_energy)
		show()
