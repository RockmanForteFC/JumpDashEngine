extends Area2D

signal on_teleport_in_complete
signal on_teleport_show_player
func _ready():
	ready_text()

func ready_text():
	$Ready_Flash_Animation.play("ReadyFlash")
	Physics.is_pause_enabled = false
	show()
	PlayerValues.refill_all_health()


func teleport_in():
	$AnimationPlayer.play("Teleport_In")

# When the animation is complete. Emit the state to the player and kill the animation node.
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Teleport_In":
		emit_signal("on_teleport_in_complete")
		yield(get_tree().create_timer(0.05),"timeout")
		hide()
		$AnimationPlayer.play("RESET")
		$Ready_Flash_Animation.play("RESET")

func play_touchdown_sound():
	$WarpInSound.play()

func emit_show():
	emit_signal("on_teleport_show_player")
