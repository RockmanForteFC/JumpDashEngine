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
export(float) var initial_delay:float = 1.5
export(float) var time_inactive:float = 1.5
export(float) var movement_speed:float = 75
export(String,"small", "large")var size:String = "large"
	
var default_head_position:Vector2
var default_texture_size:Vector2
var default_body_collision:Vector2
var default_body_position:Vector2
var direction:Vector2 = Vector2.DOWN
var stop_position: Vector2 = Vector2.ZERO


onready var head = $head
onready var body = $body
onready var body_texture: Sprite = $body_texture
onready var body_collision = $body/body_collision
onready var stop_timer:Timer = $Timer
onready var initial_delay_timer:Timer = $Initial_Delay
onready var head_sprite_offset: float = $head/Sprite.offset.y

var is_stopped:bool = true
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	for node in get_children():
		if node is Position2D:
			stop_position = node.global_position
			var size_adjustment = 24 if size == "large" else 16	
			stop_position.y -= size_adjustment
	default_head_position = head.global_position
	default_texture_size = body_texture.region_rect.size
	default_body_collision = body_collision.shape.extents
	default_body_position = body_collision.global_position
	stop_timer.wait_time = time_inactive
	initial_delay_timer.wait_time = initial_delay 
	
	set_physics_process(false)
	if not get_parent().is_connected("transition_entered",self, "activate"):
		get_parent().connect("transition_entered",self, "activate")
		get_parent().connect("transition_entered_by_teleporter",self, "activate")
	if not get_parent().is_connected("transition_exited",self, "deactivate"):
		get_parent().connect("transition_exited",self, "deactivate")
	if not stop_timer.is_connected("timeout",self, "on_start_moving"):
		stop_timer.connect("timeout",self, "on_start_moving")
	if not initial_delay_timer.is_connected("timeout",self, "_on_init"):
		initial_delay_timer.connect("timeout",self, "_on_init")

func _physics_process(delta: float) -> void:
	for body in $head/detectors/crush_detector.get_overlapping_bodies():
		_on_crush_normal(body)
	head.global_position.y = clamp(
		head.global_position.y + movement_speed * direction.y * delta,
		min(default_head_position.y, stop_position.y),
		max(default_head_position.y, stop_position.y))

func _notification(what: int)-> void:
	if what == Physics.NOTIFICATION_CHILD_PHYSICS_BODY_TRANSFORM_CHANGED:
		var base_height: float = abs(head.position.y + head_sprite_offset)
		body_texture.region_rect.size.y = base_height
		body_collision.shape.extents.y = base_height / 2.0
		body_collision.position.y = base_height / 2.0
		if not is_stopped:
			if direction == Vector2.UP:
				if head.global_position.y <= default_head_position.y:
					is_stopped = true 
					stop_timer.start()
			elif direction == Vector2.DOWN:
				if head.global_position.y >= stop_position.y:
					if $PreciseVisibilityNotifier2D.is_on_screen():
						$press_down.play()
					is_stopped = true 
					stop_timer.start()

func activate(section):
	set_physics_process(true)
	for node in get_children():
		if node is Position2D:
			stop_position = node.global_position
			stop_position.y -= 24
	head.global_position = default_head_position
	body_texture.region_rect.size = default_texture_size
	body_collision.shape.extents = default_body_collision
	body_collision.global_position = default_body_position
	direction = Vector2.DOWN
	$head/detectors/floor_detector_left.enabled = true
	$head/detectors/floor_detector_right.enabled = true
	initial_delay_timer.start()
	
func deactivate(section):
	set_physics_process(false)
	head.global_position = default_head_position
	body_texture.region_rect.size = default_texture_size
	body_collision.shape.extents = default_body_collision
	body_collision.global_position = default_body_position
	for node in get_children():
		if node is Position2D:
			stop_position = node.global_position
			stop_position.y -= 24
	$head/detectors/floor_detector_left.enabled = false
	$head/detectors/floor_detector_right.enabled = false
	direction = Vector2.DOWN
	stop_timer.stop()
	initial_delay_timer.stop()
	
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _can_crush(body) -> bool:
	return direction == Vector2.DOWN and not is_stopped and body is KinematicBody2D and body.is_on_floor()

static func _is_crushable_enemy(body) -> bool:
	return body.is_in_group("Enemies") and body.get_collision_layer_bit(Bitmask.crushable)

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func on_start_moving(direction_multiplier: float = -1.0):
	direction *= direction_multiplier
	is_stopped = false

func _on_init():
	on_start_moving(1.0)

func _on_crush_zip(body):
	if body is Player:
		body.on_crush()
	elif _is_crushable_enemy(body):
		body.on_crush()

func _on_crush_normal(body):
	if body is Player:
		if _can_crush(body):
			body.on_crush()
	elif _is_crushable_enemy(body) and _can_crush(body):
		body.on_crush()
