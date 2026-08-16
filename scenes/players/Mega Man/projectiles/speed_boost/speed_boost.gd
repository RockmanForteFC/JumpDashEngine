extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal speed_boost_ammo_tick()
#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var ammo_timer = $AmmoTimer
onready var startup_sound = $AudioStreamPlayer
var _first_tick:bool = true
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	startup_sound.play()
	PlayerValues.player.is_speed_boosted = true
	ammo_timer.connect("timeout",self,"tick_ammo")
	tick_ammo()

func _process(delta):
	global_position = PlayerValues.player.global_position

func queue_free():
	PlayerValues.player.is_speed_boosted = false
	.queue_free()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func tick_ammo():
	emit_signal("speed_boost_ammo_tick",_first_tick)
	if _first_tick:
		_first_tick = false
	ammo_timer.start()
