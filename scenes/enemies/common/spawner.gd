tool
extends Position2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export(PackedScene) var packed_scene_ref: PackedScene setget set_packed_scene_ref

var _can_respawn := true
var spawn_count_max := -1
var spawn_timer := 0.0
var spawn_info := {}

onready var _spawn_ref: Resource
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:
	add_to_group("on_screen_enemy_spawner")
	if packed_scene_ref:
		_spawn_ref = load(packed_scene_ref.get_path())

	$PreciseVisibilityNotifier2D.connect("camera_entered", self, "on_camera_entered")

	if spawn_timer > 0.0:
		$Timer.connect("timeout", self, "_on_timeout")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
# I don't know what this does
func set_packed_scene_ref(value: PackedScene) -> void:
	packed_scene_ref = value
	if Engine.editor_hint and packed_scene_ref:
		add_child((load(packed_scene_ref.get_path()).instance()).get_node("Sprite").duplicate())

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _spawn_enemy(show_animation:bool = false) -> void:
	if spawn_count_max < 0 and not _can_respawn:
		return

	var enemy: Node = _spawn_ref.instance()
	if enemy.enemy_name == "rogue_joe":
		if get_tree().get_nodes_in_group("rogue_joe_spawned").size() > 0:
			return
	if spawn_count_max < 0 or Physics.get_enemy_count(enemy.enemy_name) < spawn_count_max:
		_can_respawn = false
		enemy.position = position
		for key in spawn_info:
			enemy.set(key, spawn_info[key])
		get_parent().add_child(enemy)
		enemy.connect("tree_exited", self, "on_enemy_tree_exited", [ enemy ])
		enemy.connect("enemy_died", LevelValues, "_on_enemy_died", [enemy.unique_id])
		Physics.increase_enemy_count(enemy.enemy_name)
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func check_spawn_enemy():
	if $PreciseVisibilityNotifier2D.is_on_screen():
		_spawn_enemy()

func on_camera_entered() -> void:
	_spawn_enemy(false)
	if spawn_timer > 0.0:
		$Timer.start(spawn_timer)

func on_enemy_tree_exited(enemy: Node) -> void:
	if enemy.is_queued_for_deletion():
		Physics.decrease_enemy_count(enemy.enemy_name)
		_can_respawn = true

func _on_timeout():
	if $PreciseVisibilityNotifier2D.is_on_screen():
		_spawn_enemy(true)
