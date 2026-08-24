extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const TRIGGER_RANGE = 40.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var distance_to_player:float
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _enter():
	$"../../Sprite".hide()
	$"../../Hitbox/CollisionShape2D".set_deferred("disabled", true)
	$"../../Hitbox/CollisionShape2D2".set_deferred("disabled", true)

func _update(delta):
	distance_to_player = owner.global_position.x - PlayerValues.player.global_position.x
	if distance_to_player < 0:
		distance_to_player *= -1
	if distance_to_player < 40.0:
		emit_signal("finished", "popup")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_animation_finished(anim_name):
	pass
