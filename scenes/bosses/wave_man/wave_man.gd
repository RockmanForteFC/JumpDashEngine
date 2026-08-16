extends "res://scenes/bosses/base/boss_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	 pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
# When the player dies we need to reset the boss
func reset() -> void:
	.reset()
	$"CharacterSprites/Sprite".hide()
	set_facing_direction(Vector2.LEFT)

#face the player
func set_facing_direction(dir: Vector2) -> void:
	.set_facing_direction(dir)
	$"CharacterSprites/Sprite".flip_h = true if dir == Vector2.RIGHT else false

# if you enter the boss room from the other side, i think this corrects the position to make the boss equedistant from the player on the other side of the room.
func face_player() -> void:
	if PlayerValues.player is Player:
		set_facing_direction(Vector2(sign(PlayerValues.player.global_position.x - global_position.x), 0))
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
