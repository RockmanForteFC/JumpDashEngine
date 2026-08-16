extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const frame_limit = 5
const STAR_CRASH_SPEED:float = 150.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity
var was_hit:bool = false
var is_reflecting:bool = false
var frames = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Sprite/AnimationPlayer.play("spawn")
	set_process(false)
func _physics_process(delta):
	if did_hit_enemy:
		queue_free()
	frames += 1
	global_position = PlayerValues.player.global_position
	if not is_reflecting:
		if frames >= frame_limit:
			if Input.is_action_just_pressed("action_shoot_p1"):
				direction.x = PlayerValues.player.get_facing_direction().x
				set_process(true)

func _process(delta):
	if did_hit_enemy:
		queue_free()
	set_physics_process(false)
	velocity = direction * STAR_CRASH_SPEED
	move_and_slide(velocity, Vector2.UP)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func reflect() -> void:
	is_reflecting = true
	_free_groups()
	queue_free()
func queue_free() -> void:
	_free_groups()
	hide()
	consumed = true
	.queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("StarCrashP1"):
		remove_from_group("StarCrashP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ("spawn"):
		$Sprite/AnimationPlayer.play("spinning")

func _on_Area2D_body_entered(body):
	if !was_hit:
		was_hit = true
		if body.is_in_group("enemy_projectile_base"):
			body.get_parent().queue_free()
			queue_free()
		else:
			body.queue_free()

func _on_Area2D_area_entered(area):
	if !was_hit:
		was_hit = true
		if area.is_in_group("enemy_projectile_base"):
			area.get_parent().queue_free()
			queue_free()
		else:
			area.queue_free()


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
