extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const MOVE_SPEED = 50
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var facing_left: bool
var make_faster: bool = true
var direction: int
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _enter():
	$"../../EnemyAnimations".play("move")
	if owner.starting_direction == "Left":
		get_parent().velocity.x = MOVE_SPEED * -1
		facing_left = true
	else:
		get_parent().velocity.x = MOVE_SPEED
		facing_left = false

func _update(delta):
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_wall():
		get_parent().velocity.x *= -1
		if get_parent().velocity.x != 0 :
			direction = sign(get_parent().velocity.x)
		if direction == -1 :
			facing_left = true
		else :
			facing_left = false
	if facing_left and not $"../../FloorDetectorLeft".is_colliding() and get_parent().velocity.x != 0:
		get_parent().velocity.x *= -1
		facing_left = false
	elif not facing_left and not $"../../FloorDetectorRight".is_colliding() and get_parent().velocity.x != 0:
		get_parent().velocity.x *= -1
		facing_left = true
	if PlayerValues.player :
		if $"../../Hitbox".get_global_position().y >= (PlayerValues.player.get_global_position().y -10) \
		and $"../../Hitbox".get_global_position().y <= (PlayerValues.player.get_global_position().y +15) and make_faster \
		and get_parent().velocity.x != 0 :
			get_parent().velocity.x *= 3
			make_faster = false
		elif not make_faster:
			get_parent().velocity.x /= 3
			make_faster = true

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_Hitbox_body_entered(body):
	if body.is_in_group("PlayerWeapons") and ((body.key_name == "mega_buster" and body.has_node("AnimatedSprite")) \
	or body.key_name == "coal_ignition"):
		emit_signal("finished","flip")
	elif body.is_in_group("PlayerWeapons") and ((body.key_name == "tremor_pulse") or (body.key_name == "shiny_knuckle")) :
		owner._die()
	elif body.is_in_group("PlayerWeapons") :
		if get_parent().velocity.x != 0 :
			direction = sign(get_parent().velocity.x)
		owner._hit_points = 10
		$"../../EnemyAnimations".stop()
		get_parent().velocity.x = 0
		$"../../StunTimer".start()

func _on_StunTimer_timeout():
	$"../../EnemyAnimations".play("move")
	get_parent().velocity.x = direction * MOVE_SPEED

