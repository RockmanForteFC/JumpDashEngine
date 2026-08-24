extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const BOLT = preload("res://scenes/players/Mega Man/projectiles/thunderbolt/thunderboltsplit/thunderboltsplit.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var THUNDER_BOLT_SPEED = 200
var did_split:bool = false
var velocity:Vector2 = Vector2.ZERO
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	set_physics_process(false)
	$Audio/tstrike.play()
	$Sprite/AnimationPlayer.play("startup", -1, 2.0)
	if direction.x < 0:
		$Sprite.flip_h = true

func _physics_process(delta: float) -> void:
	move_and_slide((direction.normalized() * THUNDER_BOLT_SPEED), Vector2.UP)

func _process(delta):
	if did_hit_enemy:
		if not did_split:
				split()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func split():
	set_process(false)
	did_split = true
	var bolt1 = BOLT.instance()
	bolt1.direction = Vector2.UP
	get_parent().call_deferred("add_child", bolt1)
	bolt1.set_deferred("global_position",global_position)
	var bolt2 = BOLT.instance()
	bolt2.direction = Vector2.DOWN
	get_parent().call_deferred("add_child", bolt2)
	bolt2.set_deferred("global_position", Vector2(global_position.x,global_position.y -4))
	queue_free()

func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Audio/tstrike.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/tstrike, "finished")
	.queue_free()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func reflect() -> void:
	_free_groups()
	$Audio/deflect.play()
	direction = Vector2(-direction.x, -1)
	$Sprite.flip_h = !$Sprite.flip_h
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)


func _free_groups():
	if is_in_group("ThunderBoltP1"):
		remove_from_group("ThunderBoltP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_PreciseVisibilityNotifier2D_screen_exited():
	.queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'startup':
		$Sprite/AnimationPlayer.play('thunderbolt')
		set_physics_process(true)
