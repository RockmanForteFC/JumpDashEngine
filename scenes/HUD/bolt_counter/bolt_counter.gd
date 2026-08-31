extends Control

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var count = 0
var tween = null
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	count = PlayerValues.bolts
	$Label.text = str(PlayerValues.bolts)
	$Timer.connect("timeout",self,"fade_out")


func change_bolt():
	if Config.show_Bolts_on_pickup:
		$Timer.stop()
		$Timer.start()
		$Label.text = str(PlayerValues.bolts)
		if tween:
			tween.stop()
			tween = null
		tween = get_tree().create_tween()
		if tween:
			tween.tween_property(self, "modulate:a", 1.0, 0.6)
		yield(tween,"finished")
		tween = null

func fade_out():
	if tween:
		tween.stop()
		tween = null
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.6)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
