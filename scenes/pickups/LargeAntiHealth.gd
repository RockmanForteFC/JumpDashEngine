tool
extends Pickup

const heal_amount = 8
var velocity = Vector2(0,0)
var can_despawn = false
var emit = false

func _ready():
	item_name = "large_anti_health"
	if Engine.editor_hint:
		return
	$AnimationPlayer.play("Shine")
	if can_despawn:
		$DespawnNormal.wait_time = $DespawnNormal.wait_time * Physics.item_despawn_rate
		$DespawnNormal.start()

func _physics_process(delta):
	if !is_homing_on_player:
		if not is_on_floor():
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
	cleanup(emit and not can_despawn)

func _on_PickupDetector_body_entered(body):
	if body is Player:
		$Sprite.hide()
		$PickupDetector.collision_mask = 0
		$AudioStreamPlayer2D.play()
		body.tick_damage(heal_amount)
		emit = true
		if not $AudioStreamPlayer2D.playing:
			cleanup(emit and not can_despawn)
	elif body.is_in_group("PlayerWeapons") and body.key_name == "maelstrom_absorber":
		_maelstrom_absorb()

func _on_DespawnNormal_timeout():
	modulate.a = 0.7
	$DespawnFlashing.wait_time = $DespawnFlashing.wait_time * Physics.item_despawn_rate
	$DespawnFlashing.start()

func _on_DespawnFlashing_timeout():
	cleanup(emit and not can_despawn)

func _on_screen_exited():
	if can_despawn:
		queue_free()
