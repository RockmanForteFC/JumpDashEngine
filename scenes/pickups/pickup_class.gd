extends "res://scenes/pickups/gravity_aware_collectible.gd"

class_name Pickup
#-------------------------------------------------
#      Constants
#-------------------------------------------------

const TURN_RATE:float = 35.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal item_pickup
#-------------------------------------------------
#      Properties
#-------------------------------------------------
var item_name = ""
var SUCTION_SPEED:float = 275.0
var is_homing_on_player:bool = false
var has_physics:bool = false
var index:String = ""

export(String,"health","ammo","bolt","1up","tank","trash","bomb","key_item") var item_type:String = ""
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if Engine.editor_hint:
		return
	SUCTION_SPEED + (Physics.rng.randf_range(-10,10))
	_check_up_and_down_collisions()
	add_to_group("pickup")
	connect("item_pickup", LevelValues, "_on_item_pickup")


#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func cleanup(emit:bool = true)->void:
	if emit:
		emit_signal("item_pickup",item_name)
	queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

# Check if the item is clamped from top and bottom. If so, slightly shrink its collision, otherwise
# the body will be likely moved horizontally after move_and_slide call
func _check_up_and_down_collisions() -> void:
	var motion_result: Physics2DTestMotionResult = Physics2DTestMotionResult.new()
	var coll: CollisionShape2D = Physics.get_collision(self)
	var safe_margin: float = get("collision/safe_margin")
	for i in 2:
		var dir: float = -(2.0 * i - 1.0)
		if not Physics2DServer.body_test_motion(get_rid(), global_transform,
				dir * gravity_direction, true, safe_margin, motion_result) or \
				not is_zero_approx(motion_result.collision_safe_fraction):
			return
	coll.scale *= 0.99

#-------------------------------------------------
#      Connections
#-------------------------------------------------
