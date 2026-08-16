extends Control

const MAX_DISPLAY_SCORE := 999999999
const SCORE_DIGITS := 9
const GREY_COLOR := "#6f6f6f"
const WHITE_COLOR := "#ffffff"
const BONUS_COLOR := "#ffd447"
const PENALTY_COLOR := "#ff5252"
const BONUS_FONT_SIZE := 8
const POP_FONT_SIZE := 11
const POP_DURATION := 0.14
const STICK_DURATION := 0.28
const TALLY_DURATION := 0.35
const BONUS_REST_Y := 11.0

onready var _score_label: RichTextLabel = $ScoreWrap/ScoreRow/ScoreLabel
onready var _bonus_label: RichTextLabel = $ScoreWrap/BonusLabel
onready var _bonus_font: DynamicFont = _bonus_label.get_font("normal_font")

var _display_score := 0
var _display_adjustment := 0
var _target_score := 0
var _tally_start_score := 0
var _tally_start_adjustment := 0
var _tally_tween = null

func _ready() -> void:
	_display_score = PlayerValues.score
	_target_score = PlayerValues.score
	_reset_bonus_visuals()
	Score.connect("score_changed", self, "_on_score_changed")
	_refresh()

func _on_score_changed(new_score: int, delta: int) -> void:
	visible = Config.show_score_display
	if not visible or delta == 0:
		return

	_target_score = new_score
	if _tally_tween != null:
		_display_adjustment += delta
	else:
		_display_score = new_score - delta
		_display_adjustment = delta

	_start_tally()

func _start_tally() -> void:
	_stop_tally()
	_tally_start_score = _display_score
	_tally_start_adjustment = _display_adjustment
	_reset_bonus_visuals()
	_refresh()
	_tally_tween = get_tree().create_tween()
	_tally_tween.tween_method(self, "_apply_bonus_pop", 0.0, 1.0, POP_DURATION)
	_tally_tween.tween_method(self, "_hold_bonus", 0.0, 1.0, STICK_DURATION)
	_tally_tween.tween_method(self, "_apply_tally_progress", 0.0, 1.0, TALLY_DURATION)
	_tally_tween.tween_callback(self, "_finish_tally")

func _stop_tally() -> void:
	if _tally_tween != null:
		_tally_tween.kill()
	_tally_tween = null

func _apply_bonus_pop(progress: float) -> void:
	var size: int
	if progress < 0.45:
		var up_t := progress / 0.45
		size = int(round(lerp(BONUS_FONT_SIZE, POP_FONT_SIZE, ease(up_t, -2.5))))
	else:
		var down_t := (progress - 0.45) / 0.55
		size = int(round(lerp(POP_FONT_SIZE, BONUS_FONT_SIZE, ease(down_t, -2.0))))
	_bonus_font.size = max(BONUS_FONT_SIZE, size)

func _hold_bonus(_progress: float) -> void:
	pass

func _apply_tally_progress(progress: float) -> void:
	var eased := ease(progress, -2.0)
	_display_score = int(lerp(_tally_start_score, _target_score, eased))
	_display_adjustment = int(lerp(_tally_start_adjustment, 0, eased))
	_bonus_label.rect_position.y = lerp(BONUS_REST_Y, 0.0, eased)
	_bonus_label.modulate.a = 1.0 - eased
	_refresh()

func _finish_tally() -> void:
	_tally_tween = null
	_display_score = _target_score
	_display_adjustment = 0
	_reset_bonus_visuals()
	_refresh()

func _reset_bonus_visuals() -> void:
	_bonus_label.rect_position = Vector2(0.0, BONUS_REST_Y)
	_bonus_label.modulate = Color(1, 1, 1, 1)
	_bonus_font.size = BONUS_FONT_SIZE

func _refresh() -> void:
	visible = Config.show_score_display
	if not visible:
		return

	_score_label.bbcode_text = "[right]%s[/right]" % _format_score(_display_score)
	if _display_adjustment != 0 or _tally_tween != null:
		_bonus_label.visible = true
		_bonus_label.bbcode_text = "[right]%s[/right]" % _format_adjustment(_display_adjustment)
	else:
		_bonus_label.visible = false
		_bonus_label.bbcode_text = ""

func _format_adjustment(adjustment: int) -> String:
	if adjustment > 0:
		return "[color=%s]+%d[/color]" % [BONUS_COLOR, adjustment]
	if adjustment < 0:
		return "[color=%s]%d[/color]" % [PENALTY_COLOR, adjustment]
	return ""

func _format_score(score: int) -> String:
	var capped_score := min(score, MAX_DISPLAY_SCORE)
	var padded_score := "%0*d" % [SCORE_DIGITS, capped_score]
	if capped_score <= 0:
		return _color_digits(padded_score, GREY_COLOR)

	var first_active_index := 0
	while first_active_index < padded_score.length() and padded_score[first_active_index] == "0":
		first_active_index += 1

	var formatted := ""
	for i in padded_score.length():
		var digit := padded_score[i]
		if i < first_active_index:
			formatted += "[color=%s]%s[/color]" % [GREY_COLOR, digit]
		else:
			formatted += "[color=%s]%s[/color]" % [WHITE_COLOR, digit]
	return formatted

func _color_digits(digits: String, color: String) -> String:
	var formatted := ""
	for digit in digits:
		formatted += "[color=%s]%s[/color]" % [color, digit]
	return formatted
