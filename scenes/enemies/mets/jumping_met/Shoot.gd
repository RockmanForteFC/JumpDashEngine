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

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass
func _enter():
	owner.is_blocking = false
	$"../../AnimationPlayer".play("popup")
	
func _update(delta):
	get_parent().velocity.y = \
		clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor():
		get_parent().velocity.y = 0
		get_parent().velocity.x = 0
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _shoot():
	if !owner.is_dead:
		var b = Bullet.instance()
		owner.get_parent().call_deferred("add_child", b)
		b.direction = owner.get_facing_direction()
		b.damage = owner.projectile_damage
		b.set_deferred("global_position", owner.global_position)
	
		var b2 = Bullet.instance()
		owner.get_parent().call_deferred("add_child", b2)
		b2.direction = owner.get_facing_direction() + Vector2.UP
		b2.damage = owner.projectile_damage
		b2.set_deferred("global_position", owner.global_position)
	
		var b3 = Bullet.instance()
		owner.get_parent().call_deferred("add_child", b3)
		b3.direction = owner.get_facing_direction() + Vector2.DOWN
		b3.damage = owner.projectile_damage
		b3.set_deferred("global_position", owner.global_position)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ("popup"):
		emit_signal("finished", "jump")
