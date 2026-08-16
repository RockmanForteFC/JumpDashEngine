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
export(Color) var dark_color:Color = Color("6844fc")
export(Color) var light_color:Color = Color("b8b8f8")
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.material.set_shader_param("replace_0", dark_color)
	$AnimatedSprite.material.set_shader_param("replace_1", light_color)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
# with a low-resource spawner that will provide new enemies to kill while saving on potential lag
func _replace_with_spawner() -> void:
	spawn_info["dark_color"] = dark_color
	spawn_info["light_color"] = light_color
	._replace_with_spawner()
	
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
