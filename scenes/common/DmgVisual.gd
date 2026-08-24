extends Node2D

const SPREAD:float = 10.0

func set_and_animate(value:String, start_pos:Vector2,height:float):
	$Node/Label.text = value
#	var rotation = Physics.rng.randf_range(-14.0, 14.0)
#	var scale = Physics.rng.randf_range(0.8,1.0)
#	$Node/Label.rect_rotation = rotation
#	$Node/Label.rect_scale.x = scale
#	$Node/Label.rect_scale.y = scale
	$AnimationPlayer.play("Transition")
	var start_pos_adj = start_pos
	start_pos_adj.y -= 10

	var tween = get_tree().create_tween()
	var x_val = Physics.rng.randf_range(-SPREAD,SPREAD)
	var y_val = Physics.rng.randf_range(-height,-(height/2))
	var end_pos = Vector2(x_val, y_val) + start_pos_adj
	var tween_length = $AnimationPlayer.get_animation("Transition").length

	tween.tween_property($Node, "position",end_pos,tween_length).from(start_pos_adj)

func remove():
	queue_free()
