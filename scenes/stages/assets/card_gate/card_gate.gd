extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export var card_level_required:int = 1
export(Color) var primary_color = Color("0070ec")
export(Color) var secondary_color = Color("38b8f8")

var is_closed:bool = true
var is_within_range_to_play_sound:bool = true

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	add_to_group("key_card_door")
	
	$Sprite.material.set_shader_param("replace_0", primary_color)
	$Sprite.material.set_shader_param("replace_1", secondary_color)
	$Sprite.use_parent_material = false
	
	$Control/ColorRect/Label.text = "requires level " + str(card_level_required) + " key card"
	if PlayerValues.card_level > card_level_required:
		is_closed = false
	
	if is_closed:
		$AnimationPlayer.play("Locked")
	else:
		$AnimationPlayer.play("Unlocked")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _disable_collision():
	$CollisionShape2D.disabled = true
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_card_level_change(LEVEL):
	if is_closed:
		if LEVEL >= card_level_required:
			is_closed = false
			if is_within_range_to_play_sound:
				$OpenSound.play()
			$AnimationPlayer.play("Open")

func on_animation_finished(anim_name):
	if anim_name == "Open":
		$AnimationPlayer.play("Unlocked")

func _on_body_entered(body):
	if body is Player:
		if is_closed:
			$Control.show()

func _on_body_exited(body):
	$Control.hide()

func _on_screen_entered():
	is_within_range_to_play_sound = true

func _on_screen_exited():
	is_within_range_to_play_sound = false
