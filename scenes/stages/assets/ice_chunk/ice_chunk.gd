tool
extends StaticBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const ICE_SHATTER = preload("res://scenes/stages/effects/ice_shatter/ice_shatter_effect.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export (bool) var has_item:bool = false setget change_sprite
var is_carrying_crab:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if !has_item and !Engine.editor_hint:
		var random_number = Physics.rng.randi_range(0,100)
		if random_number == 100:
			is_carrying_crab = true
			$Sprite.texture = load("res://assets/images/sprites/level_assets/ice_chunk/ice_chunk_crab.png")
	if not get_parent().is_connected("transition_entered",self, "activate"):
		get_parent().connect("transition_entered",self, "activate")
		get_parent().connect("transition_entered_by_teleporter",self, "activate")
	if not get_parent().is_connected("transition_exited",self, "deactivate"):
		get_parent().connect("transition_exited",self, "deactivate")
	if not $ShineTimer.is_connected("timeout", self, "shine"):
		$ShineTimer.connect("timeout", self, "shine")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func shine():
	$AnimationPlayer.play("Shine")

func change_sprite(value:bool):
	has_item = value
	if has_item:
		$Sprite.texture = load("res://assets/images/sprites/level_assets/ice_chunk/ice_chunk_item.png")
	else:
		$Sprite.texture = load("res://assets/images/sprites/level_assets/ice_chunk/ice_chunk.png")

func deactivate(section):
	$IceFloor.set_process(false)
	$Sprite.hide()
	$ShineTimer.stop()
	$CollisionPolygon2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)

func activate(section):
	$IceFloor.set_process(true)
	$Sprite.show()
	$ShineTimer.start()
	$AnimationPlayer.play("RESET")
	$CollisionPolygon2D.set_deferred("disabled", false)
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_Area2D_body_entered(body):
	if body.is_in_group("PlayerWeapons"):
		if body.element == Physics.Element.fire:
			$Audio/Shatter.play()
			$AnimationPlayer.play("Break")
		else:
			$Audio/Reflect.play()
			body.reflect()
	elif body.is_in_group("Enemies"):
		if body.element == Physics.Element.fire:
			$Audio/Shatter.play()
			$AnimationPlayer.play("Break")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Break":
		var ice = ICE_SHATTER.instance()
		get_parent().call_deferred("add_child",ice)
		ice.set_deferred("global_position",global_position)
		deactivate("deactivate")
	if anim_name == "Shine":
		$ShineTimer.start()

func _on_Area2D_area_entered(area):
	if area.get_collision_layer_bit(Bitmask.enemy_projectile):
		if area.get_parent().element == Physics.Element.fire:
			$Audio/Shatter.play()
			$AnimationPlayer.play("Break")
