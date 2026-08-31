extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const METAL_BLADE_SPEED = 256
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
var frames = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Audio/blade.play()
	yield(get_tree().create_timer(0.25),"timeout")
	z_index = 400

func _physics_process(delta):
	move_and_slide((direction.normalized() * METAL_BLADE_SPEED), Vector2.UP)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Audio/blade.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/blade, "finished")
	.queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("MetalBladeP1"):
		remove_from_group("MetalBladeP1")

func reflect() -> void:
	_free_groups()
	$Audio/deflect.play()
	direction = Vector2(-direction.x, -1)
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
