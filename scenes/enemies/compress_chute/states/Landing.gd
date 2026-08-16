extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const PROJECTILE = preload("res://scenes/enemies/compress_chute/projectile/chute_projectile.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var projectile_spawner = $"../../ProjectileSpawner"
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _enter():
	var projectile = PROJECTILE.instance()
	Physics.current_stage.call_deferred("add_child",projectile)
#	projectile.get_node("Sprite").material.set_shader_param("replace_0",owner.color1)
#	projectile.get_node("Sprite").material.set_shader_param("replace_1",owner.color2)
	projectile.global_position = projectile_spawner.global_position
	projectile.velocity.y = -300
	if PlayerValues.player:
		var distance = PlayerValues.player.global_position - projectile_spawner.global_position
		var angle = projectile_spawner.global_position.angle_to_point(PlayerValues.player.global_position)
		if sign(distance.x) == -1 :
			projectile.direction = -1
		projectile.velocity.x = (abs(distance.x) / (sqrt(47/Physics.GRAVITY) + sqrt(2*abs(distance.y)/Physics.GRAVITY))) * projectile.direction * 5
	get_parent().velocity = Vector2.ZERO
	$"../../EnemyAnimations".play("Prepare-Landing")
	match get_parent().get_parent().element :
		0 : projectile.element = Physics.Element.fire
		2 : projectile.element = Physics.Element.electric
		3 : projectile.element = Physics.Element.ground
		5 : projectile.element = Physics.Element.neutral

func _update(delta):
	get_parent().velocity.y = \
		clamp(get_parent().velocity.y + Physics.GRAVITY , -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor():
		get_parent().velocity = Vector2.ZERO
	
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_animation_finished(anim_name):
	if anim_name == "Prepare-Landing" :
		emit_signal("finished","idle")
