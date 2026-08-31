extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const FLY_SPEED:float = 100.0
const Bullet : Resource = preload("res://scenes/enemies/skull_drone/projectile/skulldronebomb.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var did_timer_start:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _enter():

	owner.face_player()
	get_parent().velocity.x = FLY_SPEED * owner.get_facing_direction().x

func _update(delta):
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
func _on_Timer_timeout():
	did_timer_start= false
	emit_signal("finished", "zoom_away")


func _on_Player_Detector_Straight_body_entered(body):
	if owner.player_detected == false :
		owner.player_detected = true
		get_parent().velocity.x = 0
		$"../../Audio/Drop".play()
		var frame = $"../../AnimatedSprite".frame
		$"../../AnimatedSprite".play("dropped")
		$"../../AnimatedSprite".frame = frame
		var bullet_pos: Vector2 = $"../../BaseShootPos".global_position
		var bullet: Node = Bullet.instance()
		bullet.set_flip_direction(false)
		owner.get_parent().call_deferred("add_child",bullet)
		bullet.set_deferred("global_position", bullet_pos)
		if not did_timer_start:
			did_timer_start = true
			$"../../Timer".start()
