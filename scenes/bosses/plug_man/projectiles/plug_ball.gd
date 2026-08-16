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
export (Physics.Element)var element:int = Physics.Element.electric
export (Physics.Damage)var damage_type:int = Physics.Damage.projectile
export(float) var speed:float = 150
export(int) var damage:int = 5

var velocity:Vector2 = Vector2()
var direction:Vector2 = Vector2(-1,1)
var state:String = "fall"
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	$PlugSound.play()
	$AnimatedSprite.play("default")
	direction.y = 1
	
func _physics_process(_delta):
	if state == "fall":
		velocity = Vector2(0,speed*direction.y)
		if is_on_floor():
			state = "floor"
			direction.y = 1
	if state == "floor":
		if is_on_floor():
			velocity = Vector2(speed*direction.x,speed*direction.y)
			if is_on_wall():
				state = "wall"
				direction.y = -1
		else:
			velocity = Vector2(0,speed * direction.y)
			state = "fall"
			direction.y = 1
	if state == "wall":
		velocity = Vector2(speed*direction.x, speed * direction.y)
		if is_on_ceiling():
			direction.x = -direction.x
			state = "ceiling"
		elif not is_on_ceiling() and not is_on_wall():
			state = "floor"
	if state == "ceiling":
		velocity= Vector2(speed*direction.x, speed * direction.y)
		if floor(global_position.x) >= floor(PlayerValues.player.global_position.x -3) and \
			 floor(global_position.x) <= floor(PlayerValues.player.global_position.x +3):
			state = "fall"
			direction.y = 1
			$plugBallCollision.disabled = true
		
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

func _on_camera_exited():
	queue_free()

func _on_body_entered(body):
	if body is Player:
		body.on_hit(damage, damage_type,element)

func _on_TTL():
	queue_free()
