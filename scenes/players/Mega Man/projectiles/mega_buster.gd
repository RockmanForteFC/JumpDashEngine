extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var is_charged = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:
	if not $PreciseVisibilityNotifier2D.is_on_screen():
		queue_free()
	$Audio/Shoot.play()

	if direction.x < 0:
		$Sprite.flip_h = true
		if has_node("AnimatedSprite"):  # Charge level 2
			$AnimatedSprite.flip_h = true
			$MuzzleFlashAnimatedSprite.flip_h = true

	if has_node("AnimatedSprite"):  # Charge level 2
		damage = Physics.CHARGED_SHOT_DAMAGE
		if has_node("level3"):
			damage = Physics.UPGRADED_CHARGED_SHOT_DAMAGE
		is_charged = true
		$MuzzleFlashAnimatedSprite.set_as_toplevel(true)
		$MuzzleFlashAnimatedSprite.global_position = global_position
		$MuzzleFlashAnimatedSprite.play("muzzle_flash")
		$AnimatedSprite.play("default")

func _physics_process(delta: float) -> void:
	var _move = move_and_collide(direction.normalized() * (get_normal_speed() if not is_charged else get_charged_speed()) * delta)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func get_normal_speed():
	return Physics.SINGLE_SHOT_SPEED if not is_upgraded else Physics.SINGLE_SHOT_SPEED * 1.5

func get_charged_speed():
	return Physics.CHARGED_SHOT_SPEED if not is_upgraded else Physics.CHARGED_SHOT_SPEED * 1.5

func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Audio/Shoot.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/Shoot, "finished")
	.queue_free()

func reflect() -> void:
	_free_groups()
	$Audio/Reflect.play()
	direction = Vector2(-direction.x, -1)
	$Sprite.flip_h = !$Sprite.flip_h
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)

	if has_node("AnimatedSprite"):  # Charge level 2 and 3
		$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
		$AnimatedSprite.play("reflected")
		$CollisionShape2D.shape.extents.y = 5
		$CollisionShape2D.position.x = 0

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("BusterChargedProjectileP1"):
		remove_from_group("BusterChargedProjectileP1")
	elif is_in_group("BusterProjectilesP1"):
		remove_from_group("BusterProjectilesP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_camera_exited() -> void:
	queue_free()

func on_muzzle_flash_finish():
	$MuzzleFlashAnimatedSprite.queue_free()
