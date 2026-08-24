extends "res://scenes/enemies/base/enemy_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(String, "up", "down", "left","right") var wall_direction = "down"
export(String, "up", "down", "left","right") var moving_direction = "left"
export(int,30.0,100.0,5.0) var move_speed:float = 50.0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.play("default")
	is_blocking = true

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _replace_with_spawner() -> void:
	spawn_info["wall_direction"] = wall_direction
	spawn_info["moving_direction"] = moving_direction
	spawn_info["move_speed"] = move_speed
	._replace_with_spawner()

func _on_hit(body: PhysicsBody2D) -> void:
	._on_hit(body)
	if body and is_blocking and body.is_in_group("BeastNetP1"):
		var was_beast_net = body.is_in_group("BeastNetP1")
		_take_damage(body.damage,false, was_beast_net)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
