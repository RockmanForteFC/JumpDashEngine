extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SHOT = preload("res://scenes/enemies/joes/gattling_joes/gattling_joe_shot.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _enter():
	$"../../AnimationPlayer".play("Shoot")
	owner.face_player()

func _update(delta):
	if owner.is_on_floor():
		get_parent().velocity.y = Physics.ENEMY_IDLE_GRAVITY
	else:
		get_parent().velocity.y =  clamp(get_parent().velocity.y + (Physics.GRAVITY), -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity,Vector2.UP)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _shoot():
	if not owner.is_dead:
		$"../../Audio/Shoot".play()
		var shot = SHOT.instance()
		shot.damage = owner.projectile_damage
		shot.direction = owner.get_facing_direction()
		owner.get_parent().add_child(shot)
		shot.global_position = $"../../BaseShootPos".global_position
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_animation_finished(anim_name):
	emit_signal("finished","idle")
