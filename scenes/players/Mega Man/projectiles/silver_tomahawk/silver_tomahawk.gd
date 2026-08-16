extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const MAX_SPEED = 350
const MAX_SPEED_INCREASE = 17
const SILVER_SPEED = 200
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity = Vector2.ZERO
var is_reflecting = false
var speed_increase = 1
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Audio/Shot.play()
	if direction.x < 0:
		$AnimatedSprite.flip_h = true
	velocity = direction.normalized() * SILVER_SPEED
	velocity.y = 80 #initial shot has a downwards trajectory

func _physics_process(delta):
	if !is_reflecting:
		#starting with no no increase and every frame it will add more of an arc
		speed_increase = clamp(speed_increase + 1, -MAX_SPEED_INCREASE, MAX_SPEED_INCREASE) 
		velocity.y = clamp(velocity.y - speed_increase, -MAX_SPEED, MAX_SPEED)
		 
	move_and_slide(velocity, Vector2.UP)
	
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Audio/Shot.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/Shot, "finished")
	.queue_free()

func _free_groups():
	if is_in_group("SilverTomahawkP1"):
		remove_from_group("SilverTomahawkP1")
		
func reflect()-> void:
	_free_groups()
	$Audio/Deflect.play()
	consumed = true
	is_reflecting = true
	direction = Vector2(-direction.x , -1)
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
