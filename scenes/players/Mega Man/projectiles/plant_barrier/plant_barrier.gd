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
var velocity = Vector2.ZERO
var was_hit:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	pass
func _physics_process(delta):
	if did_hit_enemy:
		queue_free()
	global_position = PlayerValues.player.global_position
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func reflect() -> void:
	_free_groups()
	queue_free()
func queue_free() -> void:
	_free_groups()
	hide()
	consumed = true
	.queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("PlantBarrierP1"):
		remove_from_group("PlantBarrierP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_Area2D_area_entered(area):
	if !was_hit:
		was_hit = true
		if area.is_in_group("enemy_projectile_base"):
			area.get_parent().queue_free()
			queue_free()
		else:
			area.queue_free()
			queue_free()

func _on_Area2D_body_entered(body):
	if !was_hit:
		was_hit = true
		if body.is_in_group("enemy_projectile_base"):
			body.get_parent().queue_free()
			queue_free()
		else:
			body.queue_free()
			queue_free()

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
