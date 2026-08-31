extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const Bullet: Resource = preload("res://scenes/enemies/mets/mm9_met/met_9_shot.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var shot_count:int
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter():
	owner.is_blocking = false
	$"../../AnimationPlayer".play("popup")
	shot_count = 0
	$"../../shot_delay".start()
func _update(delta):
	owner.face_player()
	get_parent().velocity.y = \
		clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor():
		get_parent().velocity.y = 0
		get_parent().velocity.x = 0
func shoot():
	if !owner.is_dead:
		shot_count += 1
		var shot = Bullet.instance()
		shot.speed = 120
		shot.damage = owner.projectile_damage
		shot.direction = owner.get_facing_direction()
		Physics.current_stage.call_deferred("add_child",shot)
		shot.set_deferred("global_position", $"../../BaseShootPos".global_position)
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "popup":
		$"../../AnimationPlayer".play("spinning")
	if anim_name == "popdown":
		emit_signal("finished", "idle")

func _on_shot_delay_timeout():
	if shot_count == 3:
		$"../../AnimationPlayer".play("popdown")
	else:
		shoot()
		$"../../shot_delay".start()
