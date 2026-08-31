extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const PLUG_BALL = preload("res://scenes/bosses/plug_man/projectiles/plug_ball.tscn")
const COOLDOWN: float = 0.7
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var _standing_shoot_pos: Position2D = $"../../standing_position"
onready var _jumping_shoot_pos:Position2D = $"../../jumping_position"
onready var timer_cooldown: Timer = $"../../TimerCooldown"
onready var hop_pause:Timer = $"../../TimerHopPause"
onready var animated_sprite: AnimatedSprite = $"../../CharacterSprites/AnimatedSprite"
onready var raycast:RayCast2D = $"../../RayCastJumpShoot"
var velocity:Vector2 = Vector2()
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	 pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func jump() -> void:
	if owner.is_on_floor() and timer_cooldown.is_stopped():
		# Prevent jumping immediately when landing, and also to add a little bit of randomness to the pattern.
		# The cooldown is 0.7 * (random between 0-1) * 0.6
		# eg. 0.7 * 0.33584 * 0.6 results in a cooldown of 0.141 seconds
		timer_cooldown.start(COOLDOWN + Physics.rng.randf() * 0.6)
		emit_signal("finished", "jump")
	else:
		emit_signal("finished", "idle")

func hop() -> void:
	if owner.is_on_floor() and timer_cooldown.is_stopped():
		# Prevent jumping immediately when landing, and also to add a little bit of randomness to the pattern.
		# The cooldown is 0.7 * (random between 0-1) * 0.6
		# eg. 0.7 * 0.33584 * 0.6 results in a cooldown of 0.141 seconds
		timer_cooldown.start(COOLDOWN + Physics.rng.randf() * 0.6)
		emit_signal("finished", "hop")
	else:
		emit_signal("finished", "idle")

func shoot() -> void:
	if not owner.is_dead:
		var plug_ball = PLUG_BALL.instance()
		plug_ball.direction = owner.get_facing_direction()

		_standing_shoot_pos.position.x = abs(_standing_shoot_pos.position.x) * owner.get_facing_direction().x
		_jumping_shoot_pos.position.x = abs(_jumping_shoot_pos.position.x) * owner.get_facing_direction().x

		if not owner.is_restarting:
			owner.get_parent().add_child(plug_ball)
			if owner.is_jumping:
				plug_ball.global_position = _jumping_shoot_pos.global_position
			else:
				plug_ball.global_position = _standing_shoot_pos.global_position
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Hit":
		owner.is_invincible = false
