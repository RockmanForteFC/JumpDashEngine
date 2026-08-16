extends Area2D

func _ready():
	$AnimationPlayer.play("Dust")
	
func face_right():
	$Sprite.flip_h = true

func face_left():
	$Sprite.flip_h = false

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
