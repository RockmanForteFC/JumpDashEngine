tool
extends "res://scenes/pickups/gravity_aware_collectible.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal picked_up
#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(String,"health","ammo","bolt","1up","tank","trash","bomb","key_item") var item_type:String = ""
var was_touched:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------
var velocity:Vector2
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _ready():
	if Engine.editor_hint:
		return
	if PlayerValues.has_music_upgrade:
		queue_free()

func _physics_process(delta):
	velocity.y = clamp(velocity.y + gravity_direction.y * Physics.GRAVITY,
		-Physics.FALL_SPEED_MAX,Physics.FALL_SPEED_MAX)
	move_and_slide(velocity, -gravity_direction)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_body_entered(body):
	if body is Player and !was_touched:
		was_touched = true
		$PickupSound.play()
		PlayerValues.has_music_upgrade = true
		hide()
		emit_signal("picked_up")
		yield($PickupSound,"finished")
		queue_free()
