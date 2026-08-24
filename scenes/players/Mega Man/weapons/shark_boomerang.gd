extends "res://scenes/players/Mega Man/weapons/weapon_state.gd"
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const Projectile: Resource = preload("res://scenes/players/Mega Man/projectiles/shark_boomerang/shark_boomerang.tscn")
const SHADOW_BLADE_MAX_ON_SCREEN:int = 3
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var mega_buster: Position2D = get_node("../../MegaBusterPos")
#-------------------------------------------------
#      Processes
#-------------------------------------------------
var direction_modifier = ""

func _ready() -> void:
	_get_weapon_reference_index()
	anim_name = ANIMATIONS[animation.throw]

func _process(delta):

	if Physics.is_action_pressed("action_up_p1") and Physics.is_action_pressed("action_right_p1"):
		direction_modifier = "up_right"
	elif Physics.is_action_pressed("action_up_p1") and Physics.is_action_pressed("action_left_p1"):
		direction_modifier= "up_left"
	elif Physics.is_action_pressed("action_down_p1") and Physics.is_action_pressed("action_left_p1"):
		direction_modifier= "down_left"
	elif Physics.is_action_pressed("action_down_p1") and Physics.is_action_pressed("action_right_p1"):
		direction_modifier= "down_right"
	elif Physics.is_action_pressed("action_down_p1"):
		direction_modifier= "down"
	elif Physics.is_action_pressed("action_up_p1"):
		direction_modifier = "up"
	else:
		direction_modifier = ""

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func can_use() -> bool:
	var on_screen_bullets: Array = get_tree().get_nodes_in_group("SharkBoomerangP%s" % owner.player_number)
	return on_screen_bullets.size() < SHADOW_BLADE_MAX_ON_SCREEN and weapon_energy > 0

func use() -> void:
	if can_use():
		if not _deplete_energy():
			return

		mega_buster.position.x = abs(mega_buster.position.x) * owner.get_facing_direction().x
		owner.get_parent().add_child(_get_bullet())

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _get_bullet() -> Node:
	var bullet: Node
	bullet = Projectile.instance()
	bullet.add_to_group("SharkBoomerangP%s" % owner.player_number)

	bullet.position = owner.global_position
	bullet.direction = owner.get_facing_direction()
	if direction_modifier == "up_right":
		bullet.direction = (Vector2.UP + Vector2.RIGHT)
	if direction_modifier == "up_left":
		bullet.direction = (Vector2.UP + Vector2.LEFT)
	if direction_modifier == "up":
		bullet.direction = (Vector2.UP)
	if direction_modifier == "down":
		bullet.direction = (Vector2.DOWN)
	if direction_modifier == "down_left":
		bullet.direction = (Vector2.DOWN) + Vector2.LEFT
	if direction_modifier == "down_right":
		bullet.direction = (Vector2.DOWN) + Vector2.RIGHT

	return bullet

#-------------------------------------------------
#      Connections
#-------------------------------------------------
