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
export(Color) var color1:Color = Color("f8b800")
export(Color) var color2:Color = Color("f83800")
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Sprite.material.set_shader_param("replace_0", color1)
	$Sprite.material.set_shader_param("replace_1", color2)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _replace_with_spawner() -> void:
	spawn_info["color1"] = color1
	spawn_info["color2"] = color2
	spawn_info["element"] = element
	._replace_with_spawner()
#-------------------------------------------------
#      Connections
#-------------------------------------------------
