extends "common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
#if the player is half the screen away  minus two tiles for walls,  this will initiate triple hops
const PLAYER_DISTANCE_TO_INITIATE_HOP = (Config.DEFAULT_WINDOW_WIDTH /2) - (Physics.TILE_SIZE.x *2)
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var _timer_idle_delay: Timer = $"../../TimerIdleDelay"
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready() -> void:
	_timer_idle_delay.connect("timeout", self, "_on_timeout")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
# every time you switch to idle there is a wait of x.xx seconds before an action is performed
func _enter() -> void:
	owner.face_player()
	animated_sprite.play("Idle")
	_timer_idle_delay.start()

func _update(delta: float) -> void:
	#if not on ground. move down until ground is reached.
	owner.move_and_slide(Vector2.DOWN * Physics.GRAVITY, Vector2.UP)
#-------------------------------------------------
#      Connections
#-------------------------------------------------
#here is the magic. when a timeout on the "Idle Delay" is done, perform your logic here.
func _on_timeout() -> void:
		var distance:float = 0.0
		if PlayerValues.player.global_position.x > owner.global_position.x:
			distance = PlayerValues.player.global_position.x - owner.global_position.x
		else:
			distance = owner.global_position.x - PlayerValues.player.global_position.x

		if distance >= PLAYER_DISTANCE_TO_INITIATE_HOP:
			hop()

		else:
			# roll a random number between 0 and 5
			var random_number: float = Physics.rng.randi_range(0, 5)
			# on 0 ,1, 2 do the following
			if random_number < 2:
				emit_signal("finished", "shoot")
			else:
				jump()
