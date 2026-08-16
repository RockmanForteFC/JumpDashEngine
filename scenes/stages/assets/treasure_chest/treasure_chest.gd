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
var is_open:bool = false
export(NodePath) var linked_item:NodePath
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if linked_item.is_empty():
		queue_free()


#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func check_if_still_exists():
	var exists = get_node_or_null(linked_item)
	if !exists:
		queue_free()
		
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_Area2D_body_entered(body):
	if !is_open:
		if body.is_in_group("PlayerWeapons"):
			$HitSound.play()
			$AnimationPlayer.play("hit")
			if !body.is_piercing:
				body.queue_free()
			is_open = true
			$Sprite.texture = load("res://assets/images/sprites/level_assets/treasure_chest/chest_open.png")
			var item = get_node_or_null(linked_item)
			if item:
				z_index = 0
				item.z_index = 2
				item.global_position = $Position2D.global_position
