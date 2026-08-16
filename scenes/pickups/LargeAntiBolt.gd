tool
extends Pickup

var velocity = Vector2(0,0)
var can_despawn = false
var emit = false
export(int) var bolt_value:int = -10

func _ready():
	item_name = "large_anti_bolt"
	if Engine.editor_hint:
		return
	$AnimationPlayer.play("Spin",-1,1.25)
	if can_despawn:
		$DespawnTimerNormal.wait_time = $DespawnTimerNormal.wait_time * Physics.item_despawn_rate
		$DespawnTimerNormal.start()

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
		PlayerValues.bolts = clamp(PlayerValues.bolts + bolt_value, 0, 99999)
		emit = true
		get_tree().call_group("stage_bolt_counter","change_bolt")
	elif body.is_in_group("PlayerWeapons") and body.key_name == "maelstrom_absorber":
		_maelstrom_absorb()


func _on_DespawnTimerNormal_timeout():
	modulate.a = 0.7
	$DespawnTimerFlash.wait_time = $DespawnTimerFlash.wait_time * Physics.item_despawn_rate
	$DespawnTimerFlash.start()

func _on_DespawnTimerFlash_timeout():
	cleanup(emit and not can_despawn)

func _on_screen_exited():
	if can_despawn:
		queue_free()
