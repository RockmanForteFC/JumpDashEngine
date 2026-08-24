extends StaticBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const EXPLODE = preload("res://scenes/stages/assets/explosive_crate/explosive_crate_explosion.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var health:int = 3
var is_exploding:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if not get_parent().is_connected("transition_entered",self, "activate"):
		get_parent().connect("transition_entered",self, "activate")
		get_parent().connect("transition_entered_by_teleporter",self, "activate")
	$Timer.connect("timeout",self,"deactivate")
	$AnimatedSprite.play("Idle")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func explode():
	if !is_exploding:
		is_exploding = true
		$AnimatedSprite.play("Explode")
		$Timer.start()

func activate(throwaway = null):
	health = 3
	$CollisionShape2D.set_deferred("disabled",false)
	$projectile_detector/CollisionShape2D.set_deferred("disabled",false)
	$explosion_detector/CollisionShape2D.set_deferred("disabled",false)
	$AnimatedSprite.show()
	$AnimatedSprite.play("Idle")
	is_exploding = false

func deactivate():
	var e = EXPLODE.instance()
	call_deferred("add_child", e)
	e.set_deferred("global_position",global_position)
	$CollisionShape2D.set_deferred("disabled",true)
	$projectile_detector/CollisionShape2D.set_deferred("disabled",true)
	$explosion_detector/CollisionShape2D.set_deferred("disabled",true)
	$AnimatedSprite.hide()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _take_damage(damage):
	health -= damage
	if health <= 0:
		explode()
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_projectile_detector_body_entered(body):
	if !is_exploding:
		if body and body.is_in_group("PlayerWeapons"):
			if body.element == Physics.Element.fire:
				explode()
			body.did_hit_enemy = true
			if "consumed" in body and body.consumed:
				return
			else:
				$AudioStreamPlayer.play()
				var buster_damage: int = 1 if not "damage" in body else body.damage
				if buster_damage <= health:
					if not body.is_piercing:
						body.queue_free()
				$AudioStreamPlayer.play()
				$AnimationPlayer.play("Blink")
				_take_damage(buster_damage)


func _on_explosion_detector_area_entered(area):
	explode()


