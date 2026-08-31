extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SPAWN_LIMIT = 4
const SEGMENT = preload("res://scenes/players/Mega Man/projectiles/gemini_laser/gemini_laser_segment.tscn")
const SPAWN_OFFSET = 8
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var spawn_count = 0
var kill_count = 0

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AudioStreamPlayer.play()
	spawn()
	spawn()
	spawn()
	spawn()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func spawn():
	var spawn_pos = global_position
	spawn_pos.x = floor(spawn_pos.x + (-direction.x * (SPAWN_OFFSET* spawn_count)))
	spawn_pos.y = floor(spawn_pos.y)
	var segment = SEGMENT.instance()
	segment.direction = direction
	segment.connect("segment_despawn",self,"segment_died")
	get_parent().call_deferred("add_child", segment)
	segment.set_deferred("global_position", spawn_pos)
	spawn_count += 1

func segment_died():
	kill_count += 1
	if kill_count ==  spawn_count:
		queue_free()

func queue_free() -> void:
	_free_groups()
	consumed = true
	.queue_free()

func _free_groups():
	if is_in_group("GeminiLaserP1"):
		remove_from_group("GeminiLaserP1")
	elif is_in_group("GeminiLaserP1"):
		remove_from_group("GeminiLaserP1")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
