extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal off_screen
#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(Texture) var block_sprite:Texture = load("res://assets/images/sprites/level_assets/destructable_block/uranus_block1.png")
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Sprite.texture = block_sprite

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func explode():
	$explosion/AnimationPlayer.play("Blow_Up")
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_screen_exited():
	if is_visible_in_tree():
		emit_signal("off_screen")
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	hide()

func _on_screen_entered():
	show()
	$explosion/AnimationPlayer.play("RESET")

func _on_body_entered(body):
	if body.is_in_group("PlayerWeapons"):
		body.did_hit_enemy = true
		if not body.is_piercing:
			if !body.is_in_group("BusterChargedProjectileP1"):
				body.queue_free()
		explode()
