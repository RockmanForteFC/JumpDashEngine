tool
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
export(String, "White", "Gold") var color := "White"
var is_jumping:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if color == "Gold":
		is_blocking = true
		$Sprite.material.set_shader_param("replace_0", Color("f8b800"))
		$Sprite.material.set_shader_param("replace_1", Color("ac7c00"))
		$Gold_Sparkles.play("Shine")
		$Gold_Sparkles.show()
		emit_signal("change_state","move")
	if get_facing_direction().x == 1:
		$WallDetector.cast_to.x *= -1

func fall():
	emit_signal("change_state","fall")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func flip():
	$WallDetector.cast_to.x *= -1
	set_flip_direction(!flip_direction)

func set_flip_direction(value):
	.set_flip_direction(value)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _replace_with_spawner():
	spawn_info["color"] = color
	._replace_with_spawner()
#-------------------------------------------------
#      Connections
#-------------------------------------------------
