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

var angle = 12.0
var radius =20.0

var angle_speed = 7.0           # Radians per second
var radius_growth = 150.0        # Pixels per second

# NEW: Initial direction (can be any normalized vector)
export (Vector2) var initial_direction = Vector2(0, 1)  # Default is RIGHT
export (Vector2) var center = Vector2.ZERO
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	$AnimatedSprite.play("default")
	$AudioStreamPlayer.play()

func _process(delta: float) -> void:
	angle += angle_speed * delta
	radius += radius_growth * delta

	# Spiral offset in local polar coordinates
	var local_offset = Vector2(cos(angle), sin(angle)) * radius

	# Rotate the offset based on initial direction
	var direction_angle = initial_direction.angle()
	var rotated_offset = local_offset.rotated(direction_angle)
	position = center + rotated_offset
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
	
func queue_free() -> void:
	hide()
	$CollisionShape2D.set_deferred("disabled",true)
	_free_groups()
	consumed = true
	if $AudioStreamPlayer.playing:
		yield($AudioStreamPlayer, "finished")
	.queue_free()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("PowerStoneP1"):
		remove_from_group("PowerStoneP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_PreciseVisibilityNotifier2D_screen_exited():
	.queue_free()

