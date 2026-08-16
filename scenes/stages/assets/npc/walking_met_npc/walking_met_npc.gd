extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const WALKSPEED = 40
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity = Vector2.ZERO
var is_dead:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.play("Hide")

func _physics_process(delta):
	velocity.y = clamp(velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX,Physics.FALL_SPEED_MAX)
	move_and_slide(velocity,Vector2.UP)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func start():
	$AnimatedSprite.play("Popup")
	yield($AnimatedSprite,"animation_finished")
	$AnimatedSprite.play("Walk")
	velocity.x = Vector2.LEFT.x * WALKSPEED
	
func die():
	is_dead = true
	$die_sound.play()
	set_physics_process(false)
	$AnimatedSprite.play("Die")
	yield($die_sound,"finished")
	queue_free()
	
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_Area2D_body_entered(body):
	if !is_dead:
		if body and body.is_in_group("PlayerWeapons"):
			body.did_hit_enemy = true
			die()
			if !body.is_piercing:
				if !body.is_in_group("MineSweeperP2"):
					body.queue_free()
