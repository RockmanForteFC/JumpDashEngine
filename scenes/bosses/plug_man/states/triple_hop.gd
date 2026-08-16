extends "common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(int) var min_jump_speed := -245
var jump_count = 0
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
	if jump_count == 3:
		jump_count = 0
	if not hop_pause.is_connected("timeout", self, "on_timeout"):
		hop_pause.connect("timeout", self, "on_timeout")
	hop_pause.start()
	jump_count += 1

	velocity.y = min_jump_speed

func _update(delta: float) -> void:
	if owner.is_jumping:
		velocity.x = owner.get_facing_direction().x * 50
		velocity.y = clamp(velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
		owner.move_and_slide(velocity, Vector2.UP)

		if owner.is_on_floor():
			owner.is_jumping = false
			animated_sprite.play("Idle")
			if jump_count == 3:
				emit_signal("finished", "idle")
			else:
				emit_signal("finished", "hop")

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_timeout():
	owner.is_jumping = true
	animated_sprite.play("Jump")
