extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SHOT = preload("res://scenes/enemies/projectiles/targeted_shot.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$"../../show_timer".connect("timeout",$"../../AnimationPlayer","play",["Hide"])
	$"../../shoot_delay".connect("timeout", self, "shoot")

func _enter():
	$"../../shoot_delay".start()
	$"../../show_timer".start()
	owner.is_blocking = false
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func shoot():
	if !owner.is_dead:
		var s = SHOT.instance()
		s.damage = owner.projectile_damage
		s.damage_type = Physics.Damage.projectile
		s.element = Physics.Element.neutral
		s.z_index = owner.z_index +1
		s.direction = (PlayerValues.player.global_position - $"../../BaseShootPos".global_position)
		owner.get_parent().call_deferred("add_child", s)
		s.set_deferred("global_position",$"../../BaseShootPos".global_position)

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_animation_finished(anim_name):
	if anim_name == "Hide":
		emit_signal("finished","hide")
