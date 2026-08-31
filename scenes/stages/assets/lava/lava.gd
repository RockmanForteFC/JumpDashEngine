tool
extends StaticBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
var freeze_shader = load("res://scenes/themes/lava_freeze.tres")
#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal freeze(lava_id)
#-------------------------------------------------
#      Properties
#-------------------------------------------------
var is_hot:bool = true
export(int) var lava_id:int = 1
export(Resource)var texture:Resource
var is_freezable:bool = false
export(int, 1,20,1) var width:int = 1 setget update_width
export(int,1,20,1) var height:int = 1 setget update_height
onready var sprite = $TextureRect
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	add_to_group("lava_" + str(lava_id))
	var t = texture.duplicate()
	sprite.texture = t
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func unfreeze():
	if is_in_group("lava_frozen"):
		remove_from_group("lava_frozen")
	is_hot = true
	$CollisionShape2D.set_deferred("disabled",true)
	if sprite.texture is AnimatedTexture:
		sprite.texture.pause = false
	sprite.material.shader = null

func freeze():
	if !is_in_group("lava_frozen"):
		add_to_group("lava_frozen")
	is_hot = false
	$CollisionShape2D.set_deferred("disabled",false)
	if sprite.texture is AnimatedTexture:
		sprite.texture.pause = true
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = freeze_shader
	sprite.material.set_shader_param("from",Color("ff2b00"))
	sprite.material.set_shader_param("to",Color("64c4ea"))
	sprite.material.set_shader_param("tolerance", 0.3)

func update_width(value):
	width = value
	update()

func update_height(value):
	height = value
	update()

func update():
	$TextureRect.rect_size.x = (Physics.TILE_SIZE.x * width)
	$CollisionShape2D.shape.extents.x  =  (Physics.TILE_SIZE.x /2) * width
	$CollisionShape2D.position.x = Physics.TILE_SIZE.x/2 * (width-1)
	$Area2D/CollisionShape2D.shape.extents.x = (Physics.TILE_SIZE.x/2) * width
	$Area2D/CollisionShape2D.position.x = Physics.TILE_SIZE.x/2 * (width-1)
	$lava_collision/CollisionShape2D.shape.extents.x = (Physics.TILE_SIZE.x/2) * width
	$lava_collision/CollisionShape2D.position.x = Physics.TILE_SIZE.x/2 * (width-1)

	$PreciseVisibilityNotifier2D.rect = Rect2(-8,-8,Physics.TILE_SIZE.x * width,Physics.TILE_SIZE.y * height)

	$TextureRect.rect_size.y = (Physics.TILE_SIZE.y * height)
	$CollisionShape2D.shape.extents.y =  (Physics.TILE_SIZE.y /2) * height
	$CollisionShape2D.position.y = Physics.TILE_SIZE.y/2 * (height-1)
	$Area2D/CollisionShape2D.shape.extents.y = (Physics.TILE_SIZE.y/2) * height
	$Area2D/CollisionShape2D.position.y = Physics.TILE_SIZE.y/2 * (height-1)
	$lava_collision/CollisionShape2D.shape.extents.y = (Physics.TILE_SIZE.y/2) * height
	$lava_collision/CollisionShape2D.position.y = Physics.TILE_SIZE.y/2 * (height-1)

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_Area2D_body_entered(body):
	if $PreciseVisibilityNotifier2D.is_on_screen():
		if is_hot and body:
			if body is Player and !body.is_dead:
				if !PlayerValues.player.is_invincible:
					body.on_lava()
			elif body.is_in_group("PlayerWeapons") and body.element == Physics.Element.ice:
				freeze()
				emit_signal("freeze" ,lava_id)
