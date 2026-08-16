extends "megaman_common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity: Vector2

onready var _ray_cast: RayCast2D = get_node("../../CollisionShape2D/RayCast2D")
onready var _ray_cast2: RayCast2D = get_node("../../CollisionShape2D/RayCast2D2")
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
	animation_player.play("Caught" + owner.caught_mode)

#warning-ignore:unused_argument
func _update(delta: float) -> void:
	pass

func _handle_command(command: String) -> void:
	._handle_command(command)
	if command.begins_with("weapon_"):
		weapons.change_weapon(command)

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Caught":
		_ray_cast.force_raycast_update()
		_ray_cast2.force_raycast_update()
		if (_ray_cast.is_colliding() or _ray_cast2.is_colliding()) and owner.owner.was_previously_in_slide:
			emit_signal("finished", "slide")
		elif owner.is_on_floor():
			emit_signal("finished", "idle")
		else:
			emit_signal("finished", "jump")

