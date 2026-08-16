tool
extends StaticBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(Vector2) var velocity:Vector2 = Vector2(-60, -1) setget _set_velocity
export(int, 2, 24) var size := 8 setget _change_size
export(bool) var active := true setget _set_active
var direction:String = "Right"
export(String,"incinerate","vr","solar","challenge") var theme:String = "incinerate" setget _set_theme
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:

	for node in $SpriteInbetweens.get_children():
		node.animation = theme
	_update()
	var is_left:bool = false
	var left_theme:String = "" 
	if velocity.x < 0:
		is_left = true 
		left_theme += "_left"
	$StartSprite.animation = theme + left_theme
	$SpriteEnd.animation = theme + left_theme
	
	for child in $SpriteInbetweens.get_children():
		child.play(theme + left_theme)

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is KinematicBody2D:
			if body is Player and !body.is_dead and body.is_on_floor():
				body.move_and_slide(velocity, Vector2.UP)
			if body.is_in_group("Enemies") and body.is_on_floor() and body.get_collision_layer_bit(Bitmask.ground_entity):
				body.move_and_slide(velocity, Vector2.UP)
			if body is Pickup and body.is_on_floor():
				body.move_and_slide(velocity, Vector2.UP)
			if body.is_in_group("move_block"):
				body.global_position.x += velocity.x * delta

func _set_velocity(value: Vector2) -> void:
	velocity = value

	_update()


func _set_active(value: bool) -> void:
	active = value
	_update()

func _change_size(value: int) -> void:
	size = value
	_update()
	
func _set_theme(value: String) -> void:
	theme = value
	_update()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _update() -> void:
	if not has_node("CollisionShape2D"):
		return

	var dir: int = -1 if direction == "Left" else 1
#	constant_linear_velocity.x = velocity * dir if active else 0

	var extents := Vector2(size * 8, 8)
	$CollisionShape2D.position = extents
	$CollisionShape2D.shape.extents = extents
	
	$Area2D/CollisionShape2D.position = extents
	$Area2D/CollisionShape2D.shape.extents = Vector2(extents.x, 2)
	$Area2D/CollisionShape2D.position.y = extents.y -8
	
	var last_index: int = size - 3
	var i: int = 0
	for sprite in $SpriteInbetweens.get_children():
		sprite.visible = i <= last_index
		sprite.position.x = 24 + i * 16
		sprite.playing = active
		sprite.frame = 0
		i += 1

	$SpriteEnd.position.x = 40 + last_index * 16
	$SpriteEnd.frame = 0 
	$SpriteEnd.playing = active
	$StartSprite.frame = 0
	$StartSprite.playing = active

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
