extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const DROPLET = preload("res://scenes/stages/assets/water_drop/droplet.tscn")

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(float) var time_between_drops:float = 1.5
var is_active:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if not get_parent().is_connected("transition_entered",self, "_activate"):
		get_parent().connect("transition_entered",self, "_activate")
		get_parent().connect("transition_entered_by_teleporter",self, "_activate")
	if not get_parent().is_connected("transition_exited",self, "_deactivate"):
		get_parent().connect("transition_exited",self, "_deactivate")
	$AnimationPlayer.play("Idle")
	$Timer.wait_time = time_between_drops
	$Timer.connect("timeout", self, "drop_water")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func drop_water():
	$AnimationPlayer.play("Drop")

func make_droplet():
	if is_active:
		var droplet = DROPLET.instance()
		get_parent().call_deferred("add_child", droplet)
		droplet.set_deferred("global_position", $Position2D.global_position)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _activate(throwaway):
	is_active = true
	$Timer.start()

func _deactivate(throwaway):
	is_active = false
	$Timer.stop()
#-------------------------------------------------
#      Connections
#-------------------------------------------------




func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Drop":
		$AnimationPlayer.play("Idle")
		$Timer.start()
		make_droplet()
