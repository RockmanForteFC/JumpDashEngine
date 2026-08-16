extends Node2D

signal death_sound_done

func _ready():
	pass
	#$Edamage.play()
	#$Edie.play()
	#$Edeflect.play()


func _on_DeathSound_finished():
	emit_signal("death_sound_done")
