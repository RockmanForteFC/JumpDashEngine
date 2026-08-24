extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------

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
	owner.connect("shield_hit", self, "_on_shield_hit")
	$"../../ShieldTimer".connect("timeout",self, "_on_timeout")


func _enter():
	$"../../AnimationPlayer".play("Idle")
	$"../../ShieldTimer".start()


func _update(delta):
	owner.face_player()
	if owner.is_on_floor():
		get_parent().velocity.y = Physics.ENEMY_IDLE_GRAVITY
	else:
		get_parent().velocity.y =  clamp(get_parent().velocity.y + (Physics.GRAVITY), -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity,Vector2.UP)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_animation_finished(anim_name):
	if anim_name == "ShieldHit":
		$"../../AnimationPlayer".play("Idle")

func _on_shield_hit():
	$"../../AnimationPlayer".play("ShieldHit")
	$"../../ShieldTimer".start()

func _on_timeout():
	emit_signal("finished","prepare_to_shoot")
