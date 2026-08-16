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
var velocity:Vector2
export(float)var speed:float = 174.0
export var damage:int = 3
export (Physics.Element)var element:int = Physics.Element.neutral
export (Physics.Damage)var damage_type:int = Physics.Damage.projectile
var direction:Vector2 = Vector2(-1,-1)

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AudioStreamPlayer.play()
	velocity = direction.normalized() * speed

func _process(delta):
	move_and_slide(velocity)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_PlayerDetector_body_entered(body):
	if body is Player: 
		body.on_hit(damage, damage_type, element)
		queue_free()

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
