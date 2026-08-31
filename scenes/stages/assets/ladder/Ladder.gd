tool
extends StaticBody2D
#warning-ignore-all:return_value_discarded

#-------------------------------------------------
#      Constants
#-------------------------------------------------
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(int) var size_in_tiles := 3 setget _set_size
var last_distance_to_center:Vector2
var _players: Array = []
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:
	set_physics_process(false)
	$Ladder.connect("body_entered", self, "_on_body_entered")
	$Ladder.connect("body_exited", self, "_on_body_exited")

#warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	for player in _players:
		if not _is_player_within_section_bounds(player, Physics.current_stage.current_section):
			continue
		if not player.is_climbing and not player.is_sliding and \
				player.get_node("StateMachine").current_state != player.get_node("StateMachine/Hurt"):

			if	((((!player.is_upside_down and player.get_node("Inputs").is_action_pressed(InputHandler.Action.UP)) or (player.is_upside_down and player.get_node("Inputs").is_action_pressed(InputHandler.Action.DOWN))) and not _is_above_ladder(player) )or \
				player.get_node("Inputs").is_action_pressed(InputHandler.Action.DOWN) and _is_above_ladder(player)):

				var distance_to_center = $"Ladder/LadderCollision".global_position - player.global_position
				distance_to_center.y = 0
				if player.get_node("Inputs").is_action_pressed(InputHandler.Action.DOWN) and _is_above_ladder(player):
					player.global_position.y += 7
				last_distance_to_center = distance_to_center
				player.climb(distance_to_center)
				_set_collidable(player, false)

		if player.is_climbing:
			var distance_to_center = $"Ladder/LadderCollision".global_position - player.global_position
			distance_to_center.y = 0
			if distance_to_center != last_distance_to_center or distance_to_center != Vector2(0,0):
				last_distance_to_center = distance_to_center
				player.climb(distance_to_center)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func is_exiting_ladder(player: Player) -> bool:
	if player in _players:
		return _get_distance_to_ladder_top(player) < player.get_node("CollisionShape2D").shape.extents.y + 2
	else:
		return false

func time_to_exit(player:Player):
	if player in _players:
		return _get_distance_to_ladder_top(player) < 7
	else:
		return false

func get_top():
	return $CollisionSegment.global_position.y
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _set_collidable(player: Player, value: bool) -> void:
	player.set_collision_mask_bit(Bitmask.ladder, value)

func _is_above_ladder(player: Player) -> bool:
	return _get_distance_to_ladder_top(player) < 0

func _get_distance_to_ladder_top(player: Player) -> float:
	return floor(player.get_node("CollisionShape2D").global_position.y - \
		$CollisionSegment.global_position.y + \
		player.get_node("CollisionShape2D").shape.extents.y )

func _set_size(value: int) -> void:
	if not has_node("Ladder"):
		return

	size_in_tiles = value
	$Ladder/LadderCollision.shape.extents.y = size_in_tiles * Physics.TILE_SIZE.y / 2
	$Ladder/LadderCollision.position.y = size_in_tiles * (Physics.TILE_SIZE.y / 2) - 1
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		_players.append(body as Player)
		_players.back().ladder = self
		set_physics_process(true)

func _on_body_exited(body: PhysicsBody2D) -> void:
	var index: int = _players.find(body)
	if index == -1:
		return

	if _is_above_ladder(_players[index]) and _players[index].is_climbing:
		_players[index].move_and_collide(Vector2(0, -_get_distance_to_ladder_top(_players[index]) - 0.5))

	# _players[index].get_node("Sprite").offset.y = 0
	# _players[index].get_node("CollisionShape2D").shape.extents.y = 12
	_players[index].stop_climb()
	_players[index].ladder = null
	_set_collidable(_players[index], true)
	_players.remove(index)
	last_distance_to_center = Vector2.ZERO

	if _players.empty():
		set_physics_process(false)

static func _is_player_within_section_bounds(player: Player, section: Section) -> bool:
	var collision_shape: CollisionShape2D = Physics.get_collision(player)
	assert(collision_shape.shape is RectangleShape2D)
	var extents: Vector2 = collision_shape.shape.extents
	var player_bounding_rect: Rect2 = Rect2(collision_shape.global_position - extents, 2.0 * extents)
	var section_bounding_rect: Rect2 = Rect2(section.global_position, Vector2(section.width, section.height))
	return section_bounding_rect.encloses(player_bounding_rect)
