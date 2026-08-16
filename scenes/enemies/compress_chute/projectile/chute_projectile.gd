extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity: Vector2 = Vector2.ZERO
var direction = 1
var damage:int = 4
var element:int
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	match element :
		0 : 
			$AnimationPlayer.play("Fire")
		2: 
			$AnimationPlayer.play("Electric")
		3 : 
			$AnimationPlayer.play("Ground")
		5 : 
			$AnimationPlayer.play("Neutral")
		

func _physics_process(delta):
	velocity.y = clamp(velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX,Physics.FALL_SPEED_MAX)
	move_and_slide(velocity,Vector2.UP)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()

func _on_Area2D_body_entered(body):
	if body is Player and not body.is_dead:
		velocity.x = 0
		body.on_hit(damage, Physics.Damage.projectile,element)
