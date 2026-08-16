extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const THROW_SPEED:float = 320.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var animation_player: AnimationPlayer = get_node("../../AnimationPlayer")
var velocity:Vector2
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _enter():
	animation_player.play("Caught")

func _update(delta):
	if !owner.is_dead:
		owner.move_and_slide_with_snap(owner.get_facing_direction() * THROW_SPEED,
			owner.snap, -owner.gravity_direction)
		if owner.is_on_wall():
			owner.take_damage(3)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
