extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const PILLAR_V = preload ("res://scenes/players/Mega Man/projectiles/flame_blast/vertical/flame_blast_v.tscn")
const PILLAR_H = preload ("res://scenes/players/Mega Man/projectiles/flame_blast/horizontal/flame_blast_h.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2 = Vector2.ZERO
var curveSpeed:float = 0.0
var SPEED:float = 185.0
var did_land_on_floor:bool = false
var did_land_on_wall:bool = false
var is_reflecting:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Audio/Shoot.play()
	if direction.x < 0:
		$Sprite.flip_h = true
	velocity = Vector2(SPEED * direction.x, 0)
	$Timer.start()
func _physics_process(delta):
	curveSpeed = clamp(curveSpeed + 1,-2,12)
	velocity.y = clamp(velocity.y + curveSpeed, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	var _move = move_and_slide(velocity, Vector2.UP)
	if did_hit_enemy and !is_reflecting:
		queue_free()
	if is_on_floor():
			pillar_vertical()
	elif is_on_wall():
			pillar_horizontal()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func pillar_vertical():
	var pv = PILLAR_V.instance()
	get_parent().call_deferred("add_child", pv)
	pv.set_deferred("global_position",global_position)
	pv.add_to_group("FlameBlastP1")
	if !did_land_on_floor:
		did_land_on_floor = true
	queue_free()
	
func pillar_horizontal():
	if !did_land_on_wall:
		did_land_on_wall = true
	
	var ph = PILLAR_H.instance()
	var dr
	if direction == Vector2.LEFT:
		dr = Vector2.RIGHT 
	elif direction == Vector2.RIGHT:
		dr = Vector2.LEFT 
	ph.direction = dr
	get_parent().call_deferred("add_child", ph)
	ph.set_deferred("global_position",global_position)
	ph.add_to_group("FlameBlastP1")
	queue_free()

func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Audio/Shoot.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/Shoot, "finished")
	.queue_free()
	
func reflect() -> void:
	is_reflecting = true
	_free_groups()
	$Audio/Deflect.play()
	velocity = Vector2(-velocity.x, -1)
	$Sprite.flip_h = !$Sprite.flip_h
	
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("FlameBlastP1"):
		remove_from_group("FlameBlastP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()


func _on_Timer_timeout():
	queue_free()
