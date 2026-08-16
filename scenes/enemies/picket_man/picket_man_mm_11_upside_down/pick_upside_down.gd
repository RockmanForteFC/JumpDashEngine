extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const QUARTER_TILE = Physics.TILE_SIZE.x /2
const LOB_HEIGHT = 300 
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export(int) var damage := 5
export(int) var speed := 100
export (Physics.Element)var element:int = Physics.Element.neutral
export (Physics.Damage)var damage_type:int = Physics.Damage.projectile
onready var _area: Area2D = $PlayerDetector

var velocity:Vector2
var direction:Vector2 =  Vector2.RIGHT
var distance:Vector2

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	velocity.y = LOB_HEIGHT
	if direction.x == -1:
		distance.x += distance.y / ((QUARTER_TILE*2) * direction.x)
	else:
		distance.x -=  distance.y / ((QUARTER_TILE*2) * direction.x)

func _physics_process(delta):
	velocity.x = direction.x * (distance.x)
	velocity.y = clamp(velocity.y  - Physics.GRAVITY , -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	move_and_slide(velocity, Vector2.UP)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func reflect(normal: Vector2) -> void:
	$Reflect.play()
	direction = direction.bounce(normal)
	speed *= 2
	$"Area2D/Sprite".flip_h = !$"Area2D/Sprite".flip_h
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------


#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_screen_exit(viewport):
	queue_free()

func _on_body_entered(body):
	if body is Player:
		body.on_hit(damage,damage_type,element)

