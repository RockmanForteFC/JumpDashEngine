tool
extends "res://scenes/pickups/gravity_aware_collectible.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(String,"health","ammo","bolt","1up","tank","trash","bomb","key_item") var item_type:String = ""
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _process(_delta):
	if $CanvasLayer.visible == true:
		if Input.is_action_just_pressed("action_slide_p1") or Input.is_action_just_pressed("action_shoot_p1") or Input.is_action_just_pressed("action_jump_p1"):
			var tween = create_tween()
			tween.tween_property($CanvasLayer,"offset",Vector2(0,-66),0.25)
			yield(get_tree().create_timer(0.25),"timeout")
			$CanvasLayer.hide()
			get_tree().paused = false
			Physics.is_in_pausible_state = true
			queue_free()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_body_entered(body):
	if body is Player:
		$PickupSound.play()
		$CanvasLayer.show()
		var tween = create_tween()
		Physics.is_in_pausible_state = false
		tween.tween_property($CanvasLayer,"offset",Vector2(0,0),0.25)
		PlayerValues.can_slide = true
		get_tree().paused = true
