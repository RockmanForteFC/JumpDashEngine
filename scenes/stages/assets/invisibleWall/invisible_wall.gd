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
export(String,"Left", "Right") var unlock_from_side:String = "Left"
var player:Player = null
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if unlock_from_side == "Right":
		$Unlock/CollisionShape2D.position.x *= -1  
		
func _process(delta):
	if player and $Unlock.overlaps_body(player):
		set_collision_layer_bit(Bitmask.invisible_walls, false)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_unlock(body):
	if body is Player:
		player = body

func _on_clear_body(body):
	if body is Player:
		player = null

func _on_lock(body):
	if body is Player:
		set_collision_layer_bit(Bitmask.invisible_walls,true)
