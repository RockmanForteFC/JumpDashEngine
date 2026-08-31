extends "megaman_common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const FREEZE_TIME: float = 0.33  # Seconds
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
const DEATH:Resource = preload("res://scenes/players/Mega Man/animations/Animation_Death.tscn")
#-------------------------------------------------
#      Processes
#-------------------------------------------------
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func explode() -> void:
	$"../../EffectSpawner".spawn_death_particles()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter() -> void:
	owner.was_previously_in_slide = false
	# Stop state machine
	get_parent().set_active(false)
	owner.is_dead = true
	owner.is_in_water = false
	owner.buffering_charge = false

	# Short screen freeze before death explosion.
	get_tree().paused = true
	var pause_mode_temp := animation_player.pause_mode
	animation_player.pause_mode = PAUSE_MODE_PROCESS
	animation_player.play("Hurt")
	yield(get_tree().create_timer(FREEZE_TIME), "timeout")
	animation_player.pause_mode = pause_mode_temp
	get_tree().paused = false
	owner.emit_signal("death_freeze_finished")

	# Vanish and explode
	owner._sprite.hide()
	owner.hide()

	#when you take damage you explode. when you fall in pits you don't
	if owner.explode_on_death:
		var death = DEATH.instance()
		death.position = owner.position
		owner.connect("player_ready", death, "queue_free")
		get_parent().call_deferred("add_child", death)

#-------------------------------------------------
#      Connections
#-------------------------------------------------
