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
export(float, 0.01,3.01,1.01) var delay_offset:float = 0.01
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$delay_offset.connect("timeout",self,"go_hiding")
	$delay_offset.wait_time = delay_offset
	$delay_offset.start()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _replace_with_spawner() -> void:
	spawn_info["delay_offset"] = delay_offset
	._replace_with_spawner()

func go_hiding():
	emit_signal("change_state","hide")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
