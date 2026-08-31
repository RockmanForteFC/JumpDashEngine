extends "megaman_common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const KNOCKBACK_VELOCITY: float = Physics.DAMAGE_PUSHBACK_DISTANCE
const DAMAGE = preload("res://scenes/players/Mega Man/animations/Animation_Damage.tscn")
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
	 $"../../hurtTimer".connect("timeout",self,"exit_state")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter() -> void:
	_soft_stun()
	$"../../hurtTimer".start()
	owner.is_caught = false
	owner.buffering_charge = true
	animation_player.play("Hurt")
	velocity = Vector2()


#warning-ignore:unused_argument
func _update(delta: float) -> void:
	if !owner.is_dead:
		#knockback distance/frames is dedicated by the $AnimationPlayer.Hurt animation length
		velocity.x = -owner.get_facing_direction().x * KNOCKBACK_VELOCITY * owner.knock_back_multiplier
		velocity.y = clamp(velocity.y + owner.gravity, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
		velocity = owner.move_and_slide_with_snap(velocity, owner.snap, -owner.gravity_direction)

func _handle_command(command: String) -> void:
	._handle_command(command)
	if command.begins_with("weapon_"):
		weapons.change_weapon(command)

func exit_state():
		_ray_cast.force_raycast_update()
		_ray_cast2.force_raycast_update()
		if owner.is_caught_animation():
			emit_signal("finished", "caught")
		else:
			if (_ray_cast.is_colliding() or _ray_cast2.is_colliding()) and owner.was_previously_in_slide:
				emit_signal("finished", "slide")
			elif owner.is_on_floor():
				emit_signal("finished", "idle")
			else:
				emit_signal("finished", "jump")

func _soft_stun() -> void:
	owner.has_i_frames = true
	var damageAnimation: CanvasItem = DAMAGE.instance()
	if owner.get_facing_direction() == Vector2.RIGHT:
		damageAnimation.face_right()
	else:
		damageAnimation.face_left()
	owner.call_deferred("add_child", damageAnimation)
	owner._iframes.play("Flash")

#-------------------------------------------------
#      Connections
#-------------------------------------------------
