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

func _ready():
	pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter() -> void:
	get_tree().call_group(owner.unique_id + "_projectile", "queue_free")
	$"../../Hitbox/CollisionShape2D".set_deferred("disabled",true)
	$"../../Collider".set_deferred("disabled",true)
	if owner.is_midboss:
		_animations.play("Midboss_Death",-1,1.25)
	else:
		if owner._show_score :
			var score = owner.SCORE_LABEL.instance()
			score.score = str(owner.score)
			owner.get_parent().call_deferred("add_child",score)
			score.set_deferred("global_position", owner.global_position)
		if owner.explosion_type == "normal":
			_animations.play("Death")
		elif owner.explosion_type == "large":
			_animations.play("Bomb_Explosion")
		elif owner.explosion_type == "snow":
			_animations.play("Snow_Death")
		elif owner.explosion_type == "glitch_small":
			_animations.play("Glitch")

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _drop_item():
	if owner.drops_items:
		_item_generator.drop_item()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Death":
		owner.queue_free()
	if anim_name == "Bomb_Explosion":
		owner.queue_free()
	if anim_name == "Midboss_Death":
		owner.queue_free()
	if anim_name == "Snow_Death":
		owner.queue_free()
	if anim_name == "Glitch":
		owner.queue_free()
