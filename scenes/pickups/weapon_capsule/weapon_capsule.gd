tool
extends "res://scenes/pickups/gravity_aware_collectible.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal weapon_capsule_touched
#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2 = Vector2.ZERO
var has_gravity:bool = false
var is_enabled:bool = true
export(int, 1,3,1) var slot:int = 1 # slots can only be 1, 2, or 3,
export(String) var weapon_key_name:String = "plant_barrier"
var weapon = PlayerValues.plant_barrier
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	
	if Engine.editor_hint:
		return

	if has_gravity:
		set_physics_process(true)
	else:
		set_physics_process(false)
	weapon = PlayerValues.get(weapon_key_name)
	set_weapon()
		
func _physics_process(delta):
	velocity.y = clamp(velocity.y + gravity_direction.y * Physics.GRAVITY,
		-Physics.FALL_SPEED_MAX,Physics.FALL_SPEED_MAX)
	move_and_slide(velocity, -gravity_direction)
	if is_on_floor():
		velocity.y = 0

func disable():
	$Tween.interpolate_property(self,"scale:y",scale.y, sign(scale.y) * 0.1,sign(scale.y) * 0.7,
		Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self,"modulate:a", modulate.a,0,0.7,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	is_enabled = false
	hide()
	$Area2D/CollisionPolygon2D.set_deferred("disabled", true)

func enable():
	scale = Vector2(1,1) * scale.sign()
	modulate.a = 1
	is_enabled = true
	show()
	$Area2D/CollisionPolygon2D.set_deferred("disabled", false)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func set_weapon():
	var weapon_icon = AtlasTexture.new()
	weapon_icon.atlas = load(weapon.icon)
	weapon_icon.region = Rect2(0,0,16,16)
	$capsule/weapon_icon.texture = weapon_icon
	enable()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_pickup_touched(body):
	if is_enabled:
		if body and body is Player and !body.is_dead:
			emit_signal("weapon_capsule_touched")
			$AudioStreamPlayer.play()
			PlayerValues.obtained_weapons[str(slot)] = weapon
			for node in get_tree().get_nodes_in_group("weapon_capsule"):
				node.disable()
			PlayerValues.player.default_to_buster()
			PlayerValues.player.reinit_state_map()
			disable()
