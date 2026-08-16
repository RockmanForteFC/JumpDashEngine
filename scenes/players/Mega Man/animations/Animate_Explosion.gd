extends Node2D


func _ready():
	$AnimationPlayer.play("Death")

func _on_PreciseVisibilityNotifier2D_camera_exited():
	$Sprite.hide()
