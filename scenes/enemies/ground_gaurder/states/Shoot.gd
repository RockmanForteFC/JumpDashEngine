extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const BULLET =  preload("res://scenes/enemies/ground_gaurder/projectile/ground_guarder_bullet.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var shoot_count = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$"../../ShootTimer".connect("timeout", self, "shoot")
	$"../../InitialShootTimer".connect("timeout", self, "shoot")
	
func _enter():
	shoot_count = 0
	$"../../AnimationPlayer".play("Spin")
	$"../../InitialShootTimer".start()

func _update(delta):
	pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func shoot():
	if !owner.is_dead:
		$"../../Audio/Shoot".play()
		shoot_count += 1 
		_shoot()
		if shoot_count == 2:
			emit_signal("finished","down")
		else:
			$"../../ShootTimer".start()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _shoot():
	if owner.shoot_direction == "up":
		var bullet = BULLET.instance()
		bullet.direction = Vector2.LEFT
		owner.get_parent().call_deferred("add_child",bullet)
		bullet.set_deferred("global_position", $"../../BaseShootPos".global_position)
		
		var bullet2 = BULLET.instance()
		bullet2.direction = Vector2.LEFT + Vector2.UP
		owner.get_parent().call_deferred("add_child",bullet2)
		bullet2.set_deferred("global_position", $"../../BaseShootPos".global_position)
		
		var bullet3 = BULLET.instance()
		bullet3.direction = Vector2.RIGHT + Vector2.UP
		owner.get_parent().call_deferred("add_child",bullet3)
		bullet3.set_deferred("global_position", $"../../BaseShootPos".global_position)
		
		var bullet4 = BULLET.instance()
		bullet4.direction = Vector2.RIGHT
		owner.get_parent().call_deferred("add_child",bullet4)
		bullet4.set_deferred("global_position", $"../../BaseShootPos".global_position)
	elif owner.shoot_direction == "down":
		var bullet = BULLET.instance()
		bullet.direction = Vector2.LEFT
		owner.get_parent().call_deferred("add_child",bullet)
		bullet.set_deferred("global_position", $"../../BaseShootPos".global_position)
		
		var bullet2 = BULLET.instance()
		bullet2.direction = Vector2.LEFT + Vector2.DOWN
		owner.get_parent().call_deferred("add_child",bullet2)
		bullet2.set_deferred("global_position", $"../../BaseShootPos".global_position)
		
		var bullet3 = BULLET.instance()
		bullet3.direction = Vector2.RIGHT + Vector2.DOWN
		owner.get_parent().call_deferred("add_child",bullet3)
		bullet3.set_deferred("global_position", $"../../BaseShootPos".global_position)
		
		var bullet4 = BULLET.instance()
		bullet4.direction = Vector2.RIGHT
		owner.get_parent().call_deferred("add_child",bullet4)
		bullet4.set_deferred("global_position", $"../../BaseShootPos".global_position)
	elif owner.shoot_direction == "left":
		var bullet = BULLET.instance()
		bullet.direction = Vector2.DOWN
		owner.get_parent().call_deferred("add_child",bullet)
		bullet.set_deferred("global_position", $"../../BaseShootPos".global_position)
		
		var bullet2 = BULLET.instance()
		bullet2.direction = Vector2.DOWN + Vector2.LEFT
		owner.get_parent().call_deferred("add_child",bullet2)
		bullet2.set_deferred("global_position", $"../../BaseShootPos".global_position)
		
		var bullet3 = BULLET.instance()
		bullet3.direction = Vector2.UP + Vector2.LEFT
		owner.get_parent().call_deferred("add_child",bullet3)
		bullet3.set_deferred("global_position", $"../../BaseShootPos".global_position)
		
		var bullet4 = BULLET.instance()
		bullet4.direction = Vector2.UP
		owner.get_parent().call_deferred("add_child",bullet4)
		bullet4.set_deferred("global_position", $"../../BaseShootPos".global_position)
	elif owner.shoot_direction == "right":
		var bullet = BULLET.instance()
		bullet.direction = Vector2.DOWN
		owner.get_parent().call_deferred("add_child",bullet)
		bullet.set_deferred("global_position", $"../../BaseShootPos".global_position)
		
		var bullet2 = BULLET.instance()
		bullet2.direction = Vector2.DOWN + Vector2.RIGHT
		owner.get_parent().call_deferred("add_child",bullet2)
		bullet2.set_deferred("global_position", $"../../BaseShootPos".global_position)
		
		var bullet3 = BULLET.instance()
		bullet3.direction = Vector2.UP + Vector2.RIGHT
		owner.get_parent().call_deferred("add_child",bullet3)
		bullet3.set_deferred("global_position", $"../../BaseShootPos".global_position)
		
		var bullet4 = BULLET.instance()
		bullet4.direction = Vector2.UP
		owner.get_parent().call_deferred("add_child",bullet4)
		bullet4.set_deferred("global_position", $"../../BaseShootPos".global_position)
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_animation_finished(anim_name):
	pass
