extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SHADOW_BLADE_SPEED = 240
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
var is_reflecting:bool = false

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Audio/screech.play()
	$firing.start()

func _physics_process(delta: float) -> void:
	move_and_slide((direction.normalized() * SHADOW_BLADE_SPEED), Vector2.UP)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Audio/screech.playing:
		yield($Audio/screech, "finished")
	.queue_free()

func reflect() -> void:
	is_reflecting = true
	_free_groups()
	$Audio/deflect.play()
	direction = Vector2(-direction.x, -1)
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("ShadowBladeP1"):
		remove_from_group("ShadowBladeP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_firing_timeout():
	if !is_reflecting:
		$return.start()
		direction *= -1


func _on_return_timeout():
	if !is_reflecting:
		queue_free()


func _on_PreciseVisibilityNotifier2D_camera_exited():
	if is_reflecting:
		queue_free()
