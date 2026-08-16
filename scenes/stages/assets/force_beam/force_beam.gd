tool
extends Node2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const GROW_SPEED:float = 3.0
const COLLISION_OFFSET:float  = 7.5
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(bool) var is_casting := false setget set_is_casting
export(Vector2) var direction:Vector2 = Vector2.LEFT setget set_direction
export(float,0.10, 100.0, 0.1) var time:float = 1.0

onready var A = $force_beam/Area2D/A
onready var B = $force_beam/Area2D/B
onready var ray:RayCast2D = $force_beam
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if !PlayerValues.game_mode == "time_trial":
		if Config.lienient_timings:
			time += 1.5
	$force_beam/Area2D/A.set_deferred("disabled", true)
	$force_beam/Area2D/B.set_deferred("disabled", true)
	if not get_parent().is_connected("transition_entered",self, "_activate"):
		get_parent().connect("transition_entered",self, "_activate")
		get_parent().connect("transition_entered_by_teleporter",self, "_activate")
	if not get_parent().is_connected("transition_exited",self, "_deactivate"):
		get_parent().connect("transition_exited",self, "_deactivate")
	$Timer.connect("timeout",self,"shoot")
	

	if Engine.is_editor_hint():
		$icon.show()
	else:
		$icon.hide()
		
	if direction == Vector2.LEFT or direction == Vector2.RIGHT:
		A.shape.a = Vector2(0,COLLISION_OFFSET)
		B.shape.a = Vector2(0,-COLLISION_OFFSET)
		A.shape.b = Vector2(0,COLLISION_OFFSET)
		B.shape.b = Vector2(0,-COLLISION_OFFSET)
		ray.position.x += direction.x * 0.05
	if direction == Vector2.UP or direction == Vector2.DOWN:
		A.shape.a = Vector2(COLLISION_OFFSET,0)
		B.shape.a = Vector2(-COLLISION_OFFSET,0)
		A.shape.b = Vector2(COLLISION_OFFSET,0)
		B.shape.b = Vector2(-COLLISION_OFFSET,0)
		ray.position.y += direction.y * 0.05
	update_direction_icon()
	$force_beam/Line2D.points[1] = Vector2.ZERO
	set_physics_process(is_casting)
	
func _process(delta):
	if $PreciseVisibilityNotifier2D.is_on_screen():
		$AudioStreamPlayer.volume_db = 0
	else:
		$AudioStreamPlayer.volume_db = -80
	for body in $force_beam/Area2D.get_overlapping_bodies():
		if body and body is Player and !body.is_dead:
			body.on_laser()

func _physics_process(delta):
	if !Engine.is_editor_hint():
		var cast_point := ray.cast_to
		ray.force_raycast_update()
		
		if ray.is_colliding():
			cast_point = ray.to_local(ray.get_collision_point())
			ray.cast_to = cast_point
		else:
			ray.cast_to = ray.cast_to + (direction * GROW_SPEED)
			
		if direction == Vector2.LEFT or direction == Vector2.RIGHT:
			A.shape.b.x = cast_point.x
			B.shape.b.x = cast_point.x
		if direction == Vector2.UP or direction == Vector2.DOWN:
			A.shape.b.y = cast_point.y
			B.shape.b.y = cast_point.y

		$force_beam/Line2D.points[1] = cast_point
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func set_is_casting(cast:bool):
	is_casting = cast
	set_physics_process(is_casting)
	
func set_direction(dir:Vector2):
	direction = dir
	update_direction_icon()
	
func update_direction_icon():
	if direction == Vector2.LEFT:
		$icon.rotation_degrees = 0
	elif direction == Vector2.RIGHT:
		$icon.rotation_degrees = 180
	elif direction == Vector2.UP:
		$icon.rotation_degrees = 90
	else:
		$icon.rotation_degrees = 270
		
func reset():
	$force_beam/Area2D/A.set_deferred("disabled",true)
	$force_beam/Area2D/B.set_deferred("disabled",true)
	set_is_casting(false)
	ray.cast_to = Vector2.ZERO
	if direction == Vector2.LEFT or direction == Vector2.RIGHT:
		A.shape.b.x = ray.cast_to.x
		B.shape.b.x = ray.cast_to.x
	if direction == Vector2.UP or direction == Vector2.DOWN:
		A.shape.b.y = ray.cast_to.y
		B.shape.b.y = ray.cast_to.y
	$force_beam/Line2D.points[1] = ray.cast_to
	$Timer.stop()

func _activate(section):
	$Timer.wait_time = time
	$Timer.start()
	
func _deactivate(section):
	$Timer.stop()
	reset()

func _on_reset():
	$Timer.stop()
	reset()
	
func shoot():
	$force_beam/Area2D/A.set_deferred("disabled", false)
	$force_beam/Area2D/B.set_deferred("disabled", false)
	$AudioStreamPlayer.play()
	set_is_casting(true)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
