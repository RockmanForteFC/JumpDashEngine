extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

const WAVE:Resource = preload("res://scenes/players/Mega Man/projectiles/solar_blaze/solar_blaze_wave/solar_blaze_wave.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
var solar_speed:float = 200.0
var frames = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.play("blaze")
	$Shoot.play()
	$stop_time.start()
	$explode_timer.start()

func _physics_process(delta):
	frames += 1
	move_and_slide((solar_speed * direction.normalized()),Vector2.UP)
	if frames == 5:
		solar_speed /= 1.15
	if frames == 10:
		solar_speed /= 1.35
	if frames == 15:
		solar_speed /= 2.25
func _process(delta):
	if did_hit_enemy:
		$stop_time.stop()
		$explode_timer.stop()
		_explode()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _explode():
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	$Split.play()
	$AnimatedSprite.hide()
	_split()
	$AnimatedSprite2.visible = true
	$AnimatedSprite2.play("default")
	yield($AnimatedSprite2,"animation_finished")
	if $Split.playing:
		yield($Split,"finished")
	queue_free()
	
func _split():
	set_process(false)
	var w = WAVE.instance()
	get_parent().call_deferred("add_child", w)
	w.direction = Vector2.RIGHT
	w.set_deferred("global_position", global_position)
	
	var wl = WAVE.instance()
	get_parent().call_deferred("add_child", wl)
	wl.direction = Vector2.LEFT
	wl.set_deferred("global_position", global_position)
	
func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Shoot.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Shoot, "finished")
	.queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("SolarBlazeP1"):
		remove_from_group("SolarBlazeP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_explode_timer_timeout():
	_explode()


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()


func _on_stop_time_timeout():
	set_physics_process(false)
