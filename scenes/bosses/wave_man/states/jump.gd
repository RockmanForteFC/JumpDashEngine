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
export(int) var min_jump_speed := -285
var distance = 0
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
	animated_sprite.play("Jump")
	velocity.y = min_jump_speed
	var playerx = PlayerValues.player.global_position.x
	var wavex = owner.global_position.x
	distance = (wavex - playerx) if (wavex>playerx) else (playerx - wavex)

	#if you are within 3 tiles distance. lower the height of wave man's jump
	if distance < (Physics.TILE_SIZE.x * 3):
		velocity.y += 20

func _update(delta: float) -> void:
	velocity.x = owner.get_facing_direction().x * (distance)
	velocity.y = clamp((velocity.y - clamp(fmod(distance,8.0),0.0,8.0)) + Physics.GRAVITY , -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(velocity, Vector2.UP)

	if owner.is_on_floor():
		# 50% chance to followup a jump with a water wave.
		if Physics.rng.randf() > 0.5:
			emit_signal("finished", "water_wave")
		else:
			emit_signal("finished", "idle")

#-------------------------------------------------
#      Connections
#-------------------------------------------------
