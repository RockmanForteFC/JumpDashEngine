extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const VBOLT_SPEED = 200
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity: Vector2 = Vector2.ZERO
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Sprite/AnimationPlayer.play("verticalbolt")
	$thunder.play()

func _physics_process(delta: float) -> void:
	move_and_slide((direction.normalized() * VBOLT_SPEED), Vector2.UP)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("ThunderBoltP1"):
		remove_from_group("ThunderBoltP1")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func reflect() -> void:
	queue_free()
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_PreciseVisibilityNotifier2D_screen_exited():
	queue_free()
