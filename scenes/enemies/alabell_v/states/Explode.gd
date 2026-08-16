extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var _animations: AnimationPlayer = $"../../BaseAnimations"
onready var _item_generator := $"../../ItemGenerator"
#-------------------------------------------------
#      Processes
#-------------------------------------------------

const EXPLOSION = preload("res://scenes/enemies/common/damaging_explosion/explosion.tscn")

func _ready():
	pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter() -> void:
	$"../../Hitbox/CollisionShape2D".set_deferred("disabled",true)
	$"../../Collider".set_deferred("disabled",true)
	if owner.explosion_type == "glitch_small":
		pass
	else:
		var e = EXPLOSION.instance()
		owner.get_parent().call_deferred("add_child",e)
		e.damage = owner.projectile_damage
		e.set_deferred("global_position", $"../../BaseShootPos".global_position)
		owner.queue_free()

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _drop_item():
	if owner.drops_items:
		if owner.current_state == "freakout":
			_item_generator.drop_item()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "LargeExplosion":
		owner.queue_free()
