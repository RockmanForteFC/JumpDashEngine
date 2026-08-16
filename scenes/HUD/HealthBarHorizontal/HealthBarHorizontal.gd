extends Node2D

onready var background: Sprite = $Background
onready var pellets: Sprite = $Pellets

var pellet_count: int setget _set_pellet_count,_get_pellet_count

func _set_pellet_count(val: int):
	var num_pellets: int = int(clamp(val, 0.0, background.texture.get_width() / 2.0))
	pellets.region_rect.size.x = num_pellets * pellets.texture.get_width()

func _get_pellet_count() -> int:
	return int(pellets.region_rect.size.x / pellets.texture.get_width())
