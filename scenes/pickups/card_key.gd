tool
extends "res://scenes/pickups/gravity_aware_collectible.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal card_collected()
#-------------------------------------------------
#      Properties
#-------------------------------------------------
export var key_level = 1
export(Color) var primary_color = Color("0070ec")
export(Color) var secondary_color = Color("38b8f8")
export(String,"health","ammo","bolt","1up","tank","trash","bomb","key_item") var item_type:String = ""
#-------------------------------------------------
#      Processes
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _ready():
	if Engine.editor_hint:
		return
	if key_level <= PlayerValues.card_level:
		queue_free()
	$AnimatedSprite.material.set_shader_param("replace_0", primary_color)
	$AnimatedSprite.material.set_shader_param("replace_1", secondary_color)
	$AnimatedSprite.use_parent_material = false
	add_to_group("key_card")
	$Label.text = "LV " + str(key_level)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_collected(body):
	if body is Player:
		$CollectSound.play()
		hide()
		yield(get_tree().create_timer(0.20),"timeout")

		if PlayerValues.card_level < key_level:
			PlayerValues.card_level = key_level
		emit_signal("card_collected", key_level)
		queue_free()
