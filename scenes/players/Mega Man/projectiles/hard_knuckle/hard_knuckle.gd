extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const MAX_SPEED = 200
const SPEED_INCREASE = 5
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity = Vector2.ZERO
var is_reflecting = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	PlayerValues.player.hard_knuckle_pause_on()
	set_physics_process(false)
	$Timer.start()
	$StallTimer.start()
	$Audio/Shot.play()
	if direction.x < 0:
		$Sprite.flip_h = true

func _process(delta):
	if !is_reflecting:
		if Physics.is_action_pressed("action_down_p1"):
			global_position.y += 0.17
		if Physics.is_action_pressed("action_up_p1"):
			global_position.y += -0.17

func _physics_process(delta):
	if !is_reflecting:
		 velocity.x = clamp(velocity.x + SPEED_INCREASE * direction.x, -MAX_SPEED, MAX_SPEED)
		
	move_and_slide(velocity, Vector2.UP)
	
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	consumed = true
	PlayerValues.player.hard_knuckle_pause_off()
	if $Audio/Shot.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/Shot, "finished")
	.queue_free()

func _free_groups():
	if is_in_group("HardKnuckleP1"):
		remove_from_group("HardKnuckleP1")
		
func reflect()-> void:
	_free_groups()
	PlayerValues.player.hard_knuckle_pause_off()
	$Audio/Deflect.play()
	consumed = true
	is_reflecting = true
	velocity = Vector2(velocity.x * -1,200 * -1)
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
	PlayerValues.player.hard_knuckle_pause_off()


func _on_Timer_timeout():
	set_physics_process(true)


func _on_StallTimer_timeout():
	PlayerValues.player.hard_knuckle_pause_off()
