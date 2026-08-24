extends State
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const HARPOON = preload("res://scenes/bosses/wave_man/projectiles/harpoon.tscn")
const COOLDOWN: float = 0.7
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity := Vector2()

onready var _shoot_pos: Position2D = $"../../Position2D"

onready var timer_cooldown: Timer = $"../../TimerCooldown"
onready var animated_sprite: AnimatedSprite = $"../../CharacterSprites/AnimatedSprite"
#onready var effects: AnimationPlayer = $"../../AnimationEffects"
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

func shoot() -> void:
	if not owner.is_dead:
		var harpoon = HARPOON.instance()
		harpoon.direction = owner.get_facing_direction()
		#change the shoot position if wave man is facing the other direction
		_shoot_pos.position.x = abs(_shoot_pos.position.x) * owner.get_facing_direction().x
		if not owner.is_restarting:
			owner.get_parent().add_child(harpoon)
			harpoon.global_position = _shoot_pos.global_position
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Hit":
		owner.is_invincible = false
