extends "common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const JUMP_DISTANCE = 50
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(int) var min_jump_speed := -370
onready var _animations_special: AnimationPlayer = $"../../AnimationPlayer"
var did_shoot = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	 pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter() -> void:
	raycast.enabled = true
	owner.is_jumping = true
	animated_sprite.play("Jump")
	velocity.y = min_jump_speed

func _update(delta: float) -> void:
	if raycast.is_colliding() and not did_shoot:
		_animations_special.play("Jump_Shoot")
		shoot()
		did_shoot = true
	velocity.x = owner.get_facing_direction().x * JUMP_DISTANCE
	velocity.y = clamp(velocity.y + Physics.GRAVITY , -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(velocity, Vector2.UP)

	if owner.is_on_floor():
		owner.is_jumping = false
		raycast.enabled = false
		did_shoot = false
		emit_signal("finished", "idle")
#-------------------------------------------------
#      Connections
#-------------------------------------------------
