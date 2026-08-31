extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2 = Vector2.ZERO
export var damage:String = "1"
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Label.text = damage
	$AnimationPlayer.play("Transition")
	var distance = Physics.rng.randi_range(-20,20)
	velocity.x = distance
	velocity.y = Physics.rng.randi_range(-115, -125)

func _physics_process(delta):
	velocity.y = clamp(velocity.y + 3, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	move_and_slide(velocity, Vector2.UP)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
