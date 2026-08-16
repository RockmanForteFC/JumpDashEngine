extends "res://scenes/enemies/base/enemy_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var is_direction_locked:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func check_turn_around():
	if !is_direction_locked:
		if PlayerValues.player:
			var vector_to_player: Vector2 = PlayerValues.player.global_position - $Hitbox.global_position
			if sign(get_facing_direction().x) != sign(vector_to_player.x):
				is_direction_locked = true
				emit_signal("change_state", "turn")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
