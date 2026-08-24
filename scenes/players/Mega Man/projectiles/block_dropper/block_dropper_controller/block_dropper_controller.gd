extends  "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const BLOCK:Resource = preload("res://scenes/players/Mega Man/projectiles/block_dropper/block_dropper.tscn")
const X_OFFSET:int = 110

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var spawn_count:int = 0
var kill_count:int = 0
var top_of_screen_y = (Physics.top_tile_of_screen_view + 30)
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Drop.play()
	if direction.x < 0:
		$Position2D.position.x += X_OFFSET * -1
		$Position2D2.position.x += X_OFFSET * -1
		$Position2D3.position.x += X_OFFSET * -1
		$Position2D4.position.x += X_OFFSET * -1
#	$Position2D.global_position.y = Y_OFFSET
#	$Position2D2.global_position.y = Y_OFFSET
#	$Position2D3.global_position.y = Y_OFFSET
#	$Position2D4.global_position.y = Y_OFFSET
	spawn_block_one()
	spawn_block_two()
	spawn_block_three()
	spawn_block_four()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func spawn_block_one():
	var b = BLOCK.instance()
	var pos = $Position2D
	b.direction = direction
	call_deferred("add_child", b)
	b.set_deferred("global_position", Vector2(pos.global_position.x, top_of_screen_y))
	b.connect("block_despawn",self,"block_died")
	spawn_count += 1
func spawn_block_two():
	var b2 = BLOCK.instance()
	var pos2 = $Position2D2
	b2.direction = direction
	call_deferred("add_child", b2)
	b2.set_deferred("global_position", Vector2(pos2.global_position.x, top_of_screen_y))
	b2.connect("block_despawn",self,"block_died")
	spawn_count += 1
func spawn_block_three():
	var b3 = BLOCK.instance()
	var pos3 = $Position2D3
	b3.direction = direction
	call_deferred("add_child", b3)
	b3.set_deferred("global_position", Vector2(pos3.global_position.x, top_of_screen_y))
	b3.connect("block_despawn",self,"block_died")
	spawn_count += 1
func spawn_block_four():
	var b4 = BLOCK.instance()
	var pos4 = $Position2D4
	b4.direction = direction
	call_deferred("add_child", b4)
	b4.set_deferred("global_position", Vector2(pos4.global_position.x, top_of_screen_y))
	b4.connect("block_despawn",self,"block_died")
	spawn_count += 1

func block_died():
	kill_count += 1
	if kill_count ==  spawn_count:
		queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Drop.playing:
		hide()
		yield($Drop, "finished")
	.queue_free()

func _free_groups():
	if is_in_group("BlockDropperP1"):
		remove_from_group("BlockDropperP1")

#-------------------------------------------------
#      Connections
#-------------------------------------------------
