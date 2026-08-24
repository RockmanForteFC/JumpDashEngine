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
onready var _animations: AnimationPlayer = $"../../AnimationBase"
onready var _animations_special: AnimationPlayer = $"../../AnimationPlayer"
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	 pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter() -> void:
	Physics.is_in_boss_fight = true
	$"../../CharacterSprites/AnimatedSprite".show()
	get_tree().paused = false
	PlayerValues.player.dont_accept_inputs()
	#get_tree().paused = true
	get_tree().set_group("BossDoors", "locked", true)
	owner.face_player()

	#begin dropping down.
	_animations.play("Drop_In")

	#small delay before music starts
	yield(get_tree().create_timer(0.5),"timeout")

	owner.emit_signal("boss_ready")
	yield(_animations, "animation_finished")

	yield(get_tree().create_timer(1),"timeout")
	owner.emit_signal("start_dialog", "boss_name")
	_animations_special.play("Taunt")
	yield(_animations_special, "animation_finished")
	owner.emit_signal("hit_points_changed", 0)
	owner.life_bar.show()
	owner.emit_signal("hit_points_changed", PlayerValues.MAX_HEALTH)
	yield(owner.life_bar, "gradual_update_complete")
	owner.is_invincible = false
	owner._is_collidable = true
	owner._hit_points = PlayerValues.MAX_HEALTH
	owner.is_restarting = false
	get_tree().paused = false
	PlayerValues.player.accept_inputs()
	owner._set_activated(true)
	emit_signal("finished", "idle")
	Physics.is_in_pausible_state = true
#-------------------------------------------------
#      Connections
#-------------------------------------------------
