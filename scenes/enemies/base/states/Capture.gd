extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const TOAST = preload("res://scenes/menus/toast_message/toast_message.tscn")
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
	$"../../Hitbox/CollisionShape2D".set_deferred("disabled",true)
	_animations.play("Capture")
	var t = TOAST.instance()
	t.icon = "enemy"
	t.message = owner.enemy_name.replace("_"," ")
	Physics.current_stage.call_deferred("add_child", t)

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Capture":
		get_parent()._emit_death_signal_for_miniboss()
		owner.queue_free()
