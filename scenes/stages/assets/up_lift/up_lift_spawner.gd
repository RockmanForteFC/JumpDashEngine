extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SPAWN_DELAY_LIMIT:int = 20
const PLATFORM = preload("res://scenes/stages/assets/up_lift/up_lift_platform.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(bool) var is_active:bool = true
var spawn_delay:int = SPAWN_DELAY_LIMIT
var did_flash:bool = true
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if is_active == true:
		$AnimatedSprite.play("active")
	else:
		$AnimatedSprite.play("inactive")
	pass

func _physics_process(delta):
	spawn_delay = clamp(spawn_delay + 1, 0, SPAWN_DELAY_LIMIT)
	if !did_flash and spawn_delay == SPAWN_DELAY_LIMIT:
		did_flash = true
		$AnimationPlayer.play("flash")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func activate():
	$AnimatedSprite.play("active")
	is_active = true

func deactivate():
	$AnimatedSprite.play("inactive")
	is_active = false

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_player_detector_body_entered(body):
	if body is Player and !body.is_dead:
		if is_active and spawn_delay == SPAWN_DELAY_LIMIT:
			spawn_delay = 0
			did_flash = false
			var p = PLATFORM.instance()
			get_parent().call_deferred("add_child",p)
			p.set_deferred("global_position",$Position2D.global_position)
			p.call_deferred("activate")
