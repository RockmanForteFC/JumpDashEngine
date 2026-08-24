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

var default_head_position:Vector2
var default_texture_size:Vector2
var default_body_collision:Vector2
var default_body_position:Vector2
var direction:Vector2 = Vector2.UP
var stop_position: Vector2 setget ,_get_stop_position

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

func _physics_process(delta: float):
	for body in $head/detectors/crush_detector.get_overlapping_bodies():
		_on_crush_normal(body)
	head.global_position.y = clamp(
		head.global_position.y + movement_speed * direction.y * delta,
		min(default_head_position.y, self.stop_position.y),
		max(default_head_position.y, self.stop_position.y))

func _notification(what: int)-> void:
	if what == Physics.NOTIFICATION_CHILD_PHYSICS_BODY_TRANSFORM_CHANGED:
		var base_height: float = abs(head.position.y + head_sprite_offset)
		body_texture.region_rect.size.y = base_height
		body_collision.shape.extents.y = base_height / 2.0
		body_collision.position.y = -base_height / 2.0
		if not is_stopped:
			if direction == Vector2.UP:
				if head.global_position.y <= self.stop_position.y:
					if $PreciseVisibilityNotifier2D.is_on_screen():
						$press_down.play()
					is_stopped = true
					stop_timer.start()
			elif direction == Vector2.DOWN:
				if head.global_position.y >= default_head_position.y:
					is_stopped = true
					stop_timer.start()

func activate(section):
	$head/RayCast2D.enabled = true
	$head/RayCast2D2.enabled = true
	head.global_position = default_head_position
	body_texture.region_rect.size = default_texture_size
	body_collision.shape.extents = default_body_collision
	body_collision.global_position = default_body_position
	direction = Vector2.UP
	initial_delay_timer.start()

func deactivate(section):
	is_stopped = true
	set_physics_process(false)
	$head/RayCast2D.enabled = false
	$head/RayCast2D2.enabled = false
	head.global_position = default_head_position
	body_texture.region_rect.size = default_texture_size
	body_collision.shape.extents = default_body_collision
	body_collision.global_position = default_body_position
	direction = Vector2.UP
	stop_timer.stop()
	initial_delay_timer.stop()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _get_stop_position() -> Vector2:
	var position_marker: Node2D = get_node_or_null("Position2D")
	return position_marker.global_position if position_marker else Vector2.INF

func _can_crush() -> bool:
	return direction == Vector2.UP and not is_stopped and \
		($head/RayCast2D.is_colliding() or $head/RayCast2D2.is_colliding())

static func _is_crushable_enemy(body) -> bool:
	return body.is_in_group("Enemies") and body.get_collision_layer_bit(Bitmask.crushable)

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func on_start_moving(direction_multiplier: float = -1.0):
	direction *= direction_multiplier
	is_stopped = false

func _on_init():
	set_physics_process(true)
	on_start_moving(1.0)

func _on_crush_zip(body):
	if body is Player:
		body.on_crush()
	elif _is_crushable_enemy(body):
		body.on_crush()

func _on_crush_normal(body):
	if body is Player:
		if _can_crush():
			body.on_crush()
	elif _is_crushable_enemy(body) and _can_crush():
		body.on_crush()
