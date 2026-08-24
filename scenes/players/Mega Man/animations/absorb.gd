extends Node2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const ENERGY = preload("res://scenes/players/Mega Man/animations/energy_to_absorb.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var posx = 0
var posy = 0
var has_started:bool = false
var absorb_count = 0
var absort_times = 3
var POSITIONS:Array

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	POSITIONS = [
	Vector2(posx, posy-300),
	Vector2(posx+248,posy-260),
	Vector2(posx+288,posy),
	Vector2(posx+248,posy+260),
	Vector2(posx, posy+300),
	Vector2(posx-248, posy+260),
	Vector2(posx-288,posy),
	Vector2(posx-248,posy-260)
]

func _process(delta):
	if not has_started:
		has_started = true
		$AbsorbSound.play()
		$Timer.start()
		for n in POSITIONS:
			var energy = ENERGY.instance()
			energy.position = n
			var tween = Tween.new() #get_tree().create_tween()
			add_child(tween)
			get_parent().call_deferred("add_child", energy)
			tween.connect("tween_completed", self, "_on_tween_completed")
			tween.interpolate_property(energy, "position", n, Vector2(posx,posy), 0.8, tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween.start()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_tween_completed(object, key):
	object.queue_free()

func _on_Timer_timeout():
	$Timer.stop()
	absorb_count += 1
	if absorb_count == absort_times:
		queue_free()
	else:
		has_started = false

