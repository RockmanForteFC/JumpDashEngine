extends Area2D

var direction = "r"
const SWEAT = preload("res://scenes/players/Mega Man/animations/Animation_Sweat.tscn")

func face_left():
	direction = "l"
	
func face_right():
	direction = "r"

func _ready():
	begin()	

func begin():
	$DamageSound.play()
	var s1 = SWEAT.instance()
	var s2 = SWEAT.instance()
	var s3 = SWEAT.instance()

	if direction == "l":
		s1.face_left()
		s2.face_left()
		s3.face_left()
	else:
		s1.face_right()
		s2.face_right()
		s3.face_right()
		
	#get_parent().add_child(s1)
	#get_parent().add_child(s2)
	#get_parent().add_child(s3)
	#s1.position = $sweat_1.global_position
	#s2.position = $sweat_2.global_position
	#s3.position = $sweat_3.global_position
	
	call_deferred("add_child",s1)
	call_deferred("add_child",s2)
	call_deferred("add_child",s3)

	s1.position = Vector2(0,-24)
	s2.position = Vector2(-10,-22)
	s3.position = Vector2(10,-22)
	$AnimationPlayer.play("Damage")
	
func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
