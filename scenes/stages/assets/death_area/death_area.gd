extends Area2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var _player: Player
var is_dead = false
var tile_type:String = "spike"
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready() -> void:
	add_to_group("tile_" + tile_type)
	set_physics_process(false)
	if tile_type == "lava":
		set_collision_layer_bit(Bitmask.lava, true)
	if tile_type == "spike":
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _physics_process(_delta: float) -> void:
	if not _player.is_dead:
		match tile_type:
			"spike":
				_player.on_spike()
			"lava":
				_player.on_lava()
			"acid":
				_player.on_acid()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		_player = body as Player
		set_physics_process(true)
	if body != null and body.is_in_group("RushPhase"):
		body.despawn()


func _on_body_exited(body: PhysicsBody2D) -> void:
	if body is Player:
		set_physics_process(false)
		_player = null
