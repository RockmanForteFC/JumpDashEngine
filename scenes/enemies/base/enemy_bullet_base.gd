extends Node2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

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
export(String, "small", "medium", "large", "extralarge") var bullet_size
var direction := Vector2.RIGHT
onready var _area: Area2D = $Area2D
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if direction == Vector2.RIGHT:
		$"Area2D/Sprite".flip_h = true


func _physics_process(delta: float) -> void:
	for body in Physics.get_overlapping_bodies(_area):
		if body is Player:
			body.on_hit(damage,damage_type,element)

	position += delta * direction.normalized() * speed
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func reflect(normal: Vector2) -> void:
	$Reflect.play()
	direction = direction.bounce(normal)
	speed *= 2
	$"Area2D/Sprite".flip_h = !$"Area2D/Sprite".flip_h
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_camera_exited() -> void:
	queue_free()
