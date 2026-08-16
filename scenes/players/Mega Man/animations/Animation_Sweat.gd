extends Area2D

func _ready():
	$AnimationPlayer.play("Sweat")

func face_left():
	$Sprite.flip_h = false

func face_right():
	$Sprite.flip_h = true

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
