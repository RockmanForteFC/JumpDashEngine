extends State

#-------------------------------------------------
#      Constants
#------------------------------------------------
const TRIGGER_DISTANCE:float = 64.0
const NINJUUN = preload("res://scenes/enemies/ninjuun/ninjuun.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var can_spawn:bool = true

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$"../../spawn_timer".connect("timeout",self,"_on_timer_expired")

func _update(delta):
	if can_spawn:
		var distance_from_player = Vector2(owner.global_position.x,0).distance_to(Vector2(PlayerValues.player.global_position.x,0))
		if distance_from_player < TRIGGER_DISTANCE:
			can_spawn = false
			var n = NINJUUN.instance()
			n.connect("enemy_died",Statistics, "_on_enemy_died", [n.enemy_name])
			n.connect("enemy_died", LevelValues, "_on_enemy_died", [owner.unique_id])
			# This is a situation where we dont use call deferred because we dont want to accidentally despawn the enemy
			# because it will immediately GO UP from 0,0 and despawn before it can ever live.
			owner.get_parent().add_child(n)
			n.global_position = $"../../BaseShootPos".global_position
			$"../../spawn_timer".start()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _on_timer_expired():
	can_spawn = true
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
