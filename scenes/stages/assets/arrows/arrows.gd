tool
extends Node2D

export(String,"down","up","left","right") var direction:String = "down" setget _set_texture

func _ready():
	$AnimationPlayer.play("Arrow")

func _set_texture(value):
	direction = value
	$Sprite.texture = load("res://assets/images/sprites/level_assets/arrows/" + direction + ".png")


