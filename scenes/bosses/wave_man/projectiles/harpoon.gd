extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const HARPOON_DAMAGE = 4
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export (Physics.Element)var element:int = Physics.Element.neutral
export (Physics.Damage)var damage_type:int = Physics.Damage.projectile
var direction
var speed = 250
var _velocity:Vector2 = Vector2()
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if direction.x == 1:
		$Sprite.flip_h = true
	_velocity = Vector2(direction.x * speed,0)

func _process(delta):
	_velocity = move_and_slide(_velocity)

	for body in Physics.get_overlapping_bodies($Area2D):
		if body is Player:
			body.on_hit(HARPOON_DAMAGE, damage_type,element)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_screen_leave():
	queue_free()
