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
var is_on_screen:bool = false
export(int) var damage:int = 4
export(Physics.Element) var element:int = Physics.Element.electric
export(Physics.Damage) var damage_type:int = Physics.Damage.hazard
export(float, 0.01,3.01,1.01) var delay_offset:float = 0.01
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$delay_offset.connect("timeout",self,"shoot")
	$delay_offset.wait_time = delay_offset
	$delay_offset.start()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func shoot():
	if is_on_screen:
		$AudioStreamPlayer.play()
	$body.play("Charge")
	yield($body,"animation_finished")
	$body.play("Loop")
	$electricity.show()
	$electricity.play("default")
	$Area2D/CollisionShape2D.set_deferred("disabled",false)
	$shoot_timer.start()
	yield($shoot_timer,"timeout")
	stop()

func stop():
	$body.play("Idle")
	$stop_timer.start()
	$Area2D/CollisionShape2D.set_deferred("disabled",true)
	$electricity.hide()
	yield($stop_timer,"timeout")
	shoot()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_entered():
	is_on_screen = true

func _on_PreciseVisibilityNotifier2D_camera_exited():
	is_on_screen = false

func _on_Area2D_body_entered(body):
	if body is Player and !body.is_dead:
		body.on_hit(damage,damage_type,element)
