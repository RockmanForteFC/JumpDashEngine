extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SEED_SPEED = 148
const PLANT = preload("res://scenes/players/Mega Man/projectiles/life_seed/life_seed_plant.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var gravity_direction: Vector2 = Vector2.DOWN
var is_reflecting:bool = false

onready var velocity: Vector2 = direction * SEED_SPEED + -40 * gravity_direction

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Audio/Shoot.play()

func _physics_process(delta):
	velocity.y = clamp(velocity.y + gravity_direction.y * Physics.GRAVITY_WATER,
		-Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	move_and_slide(velocity, -gravity_direction)
	if did_hit_enemy and !is_reflecting:
		queue_free()
		set_physics_process(false)
	if is_on_wall():
		velocity.x = 0
	if is_on_floor():
		$Audio/Land.play()
		set_physics_process(false)
		$AnimatedSprite.play("Break Open")
		spawn_flower()
		yield($AnimatedSprite,"animation_finished")
		queue_free()
		
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Audio/Shoot.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/Shoot, "finished")
	if $Audio/Land.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/Land, "finished")
	.queue_free()

func spawn_flower():
	var p = PLANT.instance()
	p.scale.y *= gravity_direction.y
	p.gravity_direction = gravity_direction
	p.add_to_group("LifeSeedP1")
	get_parent().call_deferred("add_child",p)
	p.set_deferred("global_position", $Position2D.global_position)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("LifeSeedP1"):
		remove_from_group("LifeSeedP1")
		
func reflect() -> void:
	is_reflecting = true
#	_free_groups()
#	$CollisionShape2D.set_deferred("disabled", true)
	$Audio/deflect.play()
	direction = -Vector2(direction.x, gravity_direction.y)
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
