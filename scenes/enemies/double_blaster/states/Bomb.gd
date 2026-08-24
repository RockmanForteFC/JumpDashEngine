extends "common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const BOMB = preload("res://scenes/enemies/double_blaster/double_blaster_projectile/db_projectile.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var distance:Vector2 = Vector2.ZERO
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$"../../IdleBombTimer".connect("timeout", self, "lob_bomb")
	$"../../After_bomb_cooldown".connect("timeout",self,"emit_signal",["finished","idle"])

func _enter():
	if PlayerValues.player and !PlayerValues.player.is_dead:
		distance = PlayerValues.player.global_position - $"../../BombPosition".global_position
	owner.is_direction_locked = false
	get_parent().state = "bomb"
	$"../../AnimatedSprite".play("Bomb")
	$"../../IdleBombTimer".start()
	yield($"../../AnimatedSprite","animation_finished")
	$"../../AnimatedSprite".play("Idle")
	$"../../After_bomb_cooldown".start()

func _update(delta):
	._update(delta)
	owner.check_turn_around()

func _exit():
	distance = Vector2.ZERO
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func lob_bomb():
	if !owner.is_dead and distance.x != 0:
		var projectile = BOMB.instance()
		Physics.current_stage.call_deferred("add_child",projectile)
		projectile.set_deferred("global_position", $"../../BombPosition".global_position)
		projectile.velocity.y = -300
		if sign(distance.x) == -1 :
			projectile.direction = -1
		projectile.velocity.x = (abs(distance.x) / (sqrt(47/Physics.GRAVITY) + sqrt(2*abs(distance.y)/Physics.GRAVITY))) * projectile.direction * 4.25

		get_parent().velocity = Vector2.ZERO
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
