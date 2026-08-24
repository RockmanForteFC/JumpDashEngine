extends "common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const WATER_WAVE = preload("res://scenes/bosses/wave_man/projectiles/water_wave.tscn")
const distance_from_center_of_waveman_to_floor = 3
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var _timer_strike := $"../../TimerWaterWave"
onready var _animation_player := $"../../AnimationPlayer"
var _water_wave: Node2D
var _water_pos: Vector2
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	_timer_strike.connect("timeout", self, "_on_strike_pos_timeout")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func get_water_position()->Vector2:
	var x: float = owner.global_position.x
	if PlayerValues.player is Player:
		x = PlayerValues.player.global_position.x
		var xoffset = Physics.rng.randi_range(10,32)
		xoffset *= 1 if randf() >= 0.5 else -1
		x += xoffset


	var y: float = owner.global_position.y + distance_from_center_of_waveman_to_floor

	return Vector2(x, y)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter():
	_animation_player.play("Water_Wave")
	_water_wave = WATER_WAVE.instance()
	_timer_strike.start()

func _update(_delta):
	pass
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_animation_finished(anim_name: String) -> void:
	._on_animation_finished(anim_name)
	if anim_name == "Water_Wave":
		emit_signal("finished", "idle")

func _on_strike_pos_timeout():
	_water_pos = get_water_position()
	if not owner.is_restarting:
		owner.get_parent().add_child(_water_wave)
		if not owner.is_dead:
			_water_wave.global_position = _water_pos
