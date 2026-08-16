tool
extends StaticBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SPLASH = preload("res://scenes/stages/assets/water/effects/splash.tscn")
const BUBBLE = preload("res://scenes/stages/assets/water/effects/bubble.tscn")
const COLD_WATER = preload("res://scenes/stages/assets/water/effects/cold_water_filter.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export var textureTop:Texture 
export var textureBody:Texture
export(int, 16, 1024, 16) var width := 16 setget _set_width
export(int, 16, 1024, 16) var height := 16 setget _set_height
export(bool) var is_cold_water:bool = false
export(bool) var is_upside_down:bool = false
var player:LadderController 
var _canvas = null
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	add_to_group("Water")
	$WaterTop.texture = textureTop
	$WaterBody.texture = textureBody
	if is_cold_water:
		$WaterWarmupTimer.connect("timeout",self,"_on_warmup_water")

func _physics_process(_delta):
	if not player == null and !PlayerValues.player.is_dead and $Body.overlaps_body(player): 
		if not PlayerValues.player.is_in_water:
			 PlayerValues.player.is_in_water = true
		if  is_cold_water and PlayerValues.player.is_in_water and !_canvas:
			_canvas = COLD_WATER.instance()
			_canvas.connect("tick_health",self,"_on_cold_water_timeout")
			add_child(_canvas)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _on_cold_water_timeout():
	if player != null:
		$Audio/ColdWaterTick.play()
		PlayerValues.player.tick_damage(1)
	else:
		if _canvas != null:
			_canvas.queue_free()
			_canvas = null

func _on_warmup_water():
	is_cold_water = true

func _set_width(value: int) -> void:
	width = value
	_update_size()

func _set_height(value: int) -> void:
	height = value
	_update_size()

func _update_size() -> void:
	var extents := Vector2(width / 2.0, height / 2.0)
	$Top.shape.b.x = width
	$WaterShape.update()
	$Body/WaterBodyCollision.shape.extents = extents
	$Body/WaterBodyCollision.position = extents
	extents *= 2
	$WaterTop.rect_size.x = extents.x
	if height > Physics.TILE_SIZE.y:
		extents.y -= 16
		$WaterBody.rect_size = extents
		$WaterBody.show()
	$Body/WaterBodyCollision.position.x -= 8
	$Body/WaterBodyCollision.position.y -= 8
		
func _make_splash():
	$Audio/Splash.play()
	var splash = SPLASH.instance()
	var pos = Vector2(player.global_position.x,global_position.y-8)
	if is_upside_down:
		splash.scale.y = -1
		pos.y += 16
	splash.global_position = pos
	owner.call_deferred("add_child",splash)

func _make_bubble():
	if not PlayerValues.player.is_climbing:
		if get_tree().get_nodes_in_group("Bubble").size() <= 5:
			var bubble = BUBBLE.instance()
			bubble.water_body = self
			bubble.position = PlayerValues.player.global_position
			owner.call_deferred("add_child",bubble)
		else:
			printerr("bubble cannot make")
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_water_entered(body):
	if body is LadderController:
		player = body
		if not PlayerValues.player.is_in_water:
			PlayerValues.player.is_in_water = true
			_make_splash()
			$BubbleTimer.start()
		PlayerValues.player.number_of_in_contact_water += 1
	if body.is_in_group("PlayerWeapons") and (body.is_in_group("CoalIgnitionP1")or body.is_in_group("CoalIgnitionFireP1")) and is_cold_water:
		is_cold_water = false
		if _canvas != null:
			_canvas.queue_free()
			_canvas = null
		$WaterWarmupTimer.start()

func _on_water_exited(body):
	if body == player:
		if not PlayerValues.player.number_of_in_contact_water > 1:
			_make_splash()
			PlayerValues.player.is_in_water = false 
			$BubbleTimer.stop()
		PlayerValues.player.number_of_in_contact_water = clamp(PlayerValues.player.number_of_in_contact_water -1,0,100)
		player = null
		if _canvas != null:
			_canvas.queue_free()
			_canvas = null
	if body.is_in_group("Bubble"):
		body.queue_free()
		
func _on_bubble_timer():
	if PlayerValues.player.number_of_in_contact_water >= 1:
		_make_bubble()
		$BubbleTimer.start()
	else:
		pass
