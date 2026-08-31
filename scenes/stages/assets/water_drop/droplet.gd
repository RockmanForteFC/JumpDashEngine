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
var velocity:Vector2

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimationPlayer.play("Idle")
	velocity = Vector2(0,0)

func _physics_process(delta):
	velocity.y = clamp(velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	move_and_slide(velocity, Vector2.UP)

	if is_on_floor():
		set_physics_process(false)
		$AnimationPlayer.play("Splash")
		$splash_sfx.play()

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
	if anim_name == "Splash":
		if $splash_sfx.playing:
			hide()
			yield($splash_sfx, "finished")
		queue_free()

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()

func _on_Area2D_area_entered(area):
	$splash_sfx.stream = load("res://assets/audio/environment/splash.wav")
	set_physics_process(false)
	$AnimationPlayer.play("Splash")
	$splash_sfx.play()
