tool
extends Pickup

var velocity = Vector2(0,0)

#These need to be set through the level designer options
enum TANKS {E,W,M}
export (TANKS) var TankType = TANKS.E
var tankLetter = ""
#By Default Tanks do not fall. they will float in the air
export var HasGravity = false
#tanks are not dropped by enemies. so they cannot despawn. emit should be defaulted to true
var emit = true
var can_despawn = false

func _ready():
	if Engine.editor_hint:
		return
	add_to_group("pickup")
	if TankType == TANKS.E:
		$AnimationPlayer.play("E")
		tankLetter = "E"
	elif TankType == TANKS.W:
		$AnimationPlayer.play("W")
		tankLetter = "W"
	else:
		$AnimationPlayer.play("M")
		tankLetter = "M"
	item_name = (tankLetter + "_tank").to_lower()

func _physics_process(delta):
	if !is_homing_on_player:
		if HasGravity and not is_on_floor():
			velocity.y = clamp(velocity.y + gravity_direction.y * Physics.GRAVITY,
				-Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
		elif is_on_floor():
			velocity.y = 0
		var _movement = move_and_slide(velocity, -gravity_direction)
		if is_on_floor():
			velocity = Vector2.ZERO
	else:
		var distance = (PlayerValues.player.global_position - global_position).normalized()
		var desired_velocity = distance * SUCTION_SPEED
		velocity = velocity.linear_interpolate(desired_velocity, TURN_RATE * delta )
		move_and_slide(velocity)
		if PlayerValues.player.is_dead:
			queue_free()

func _maelstrom_absorb():
	if !is_homing_on_player:
		velocity = Vector2.ZERO * SUCTION_SPEED
		$CollisionShape2D.set_deferred("disabled", true)
		is_homing_on_player = true

func _on_AudioStreamPlayer2D_finished():
	cleanup(emit)

func _on_PickupDetector_body_entered(body):
	if body is Player:
		$Sprite.hide()
		$PickupDetector.collision_mask = 0
		$AudioStreamPlayer2D.play()
		PlayerValues.add_tank(tankLetter)
	elif body.is_in_group("PlayerWeapons") and body.key_name == "maelstrom_absorber":
		_maelstrom_absorb()

func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play("Idle")
