extends StaticBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export (String, "Right", "Left","Up","Down") var direction:String = "Right"
export (float) var time_between_fire:float = 2.5
var is_active:bool = false
var is_timer_running:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	$Timer.wait_time = time_between_fire
	$AnimatedSprite.set_animation(direction)
	$Timer.connect("timeout", self, "prepare")

func _physics_process(delta):
	if is_active and not is_timer_running:
		is_timer_running = true
		$Timer.start()

	if direction == "Left" or direction == "Right":
		for body in $Firebar_h.get_overlapping_bodies():
			if body is Player:
				body.on_hit(4, Physics.Damage.hazard,Physics.Element.fire)
			elif body.is_in_group("Tar"):
				body.catch_fire()
		for area in $Firebar_h.get_overlapping_areas():
			if area.is_in_group("Tar"):
				area.get_parent().catch_fire()

	elif direction == "Up" or direction == "Down":
		for body in $firebar_v.get_overlapping_bodies():
			if body is Player:
				body.on_hit(4, Physics.Damage.hazard,Physics.Element.fire)
			elif body.is_in_group("Tar"):
				body.catch_fire()
		for area in $firebar_v.get_overlapping_areas():
			if area.is_in_group("Tar"):
				area.catch_fire()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func prepare():
	$AnimationPlayer.play("prepare_to_fire")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_PreciseVisibilityNotifier2D_camera_entered():
	$Timer.stop()
	is_active = true
	is_timer_running = false

func _on_PreciseVisibilityNotifier2D_camera_exited():
	$Timer.stop()
	is_active = false
	is_timer_running = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "prepare_to_fire":
		if is_active:
			$AudioStreamPlayer.play()
			$AnimationPlayer.play("fire_" + direction.to_lower(),-1, 0.75)
	else:
		if is_active:
			$Timer.start()
