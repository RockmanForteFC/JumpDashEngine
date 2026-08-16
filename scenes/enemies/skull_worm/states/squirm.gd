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

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _enter():
	$"../../AnimationPlayer".play("Squirm",-1,0.5)
	
func _update(delta):
	get_parent().velocity.x = 20 * owner.get_facing_direction().x
	get_parent().velocity.y = Physics.GRAVITY
	owner.move_and_slide(get_parent().velocity,Vector2.UP)
	if owner.is_on_wall():
		$"../../Hitbox/CollisionShape2D2".position.x *= -1
		if owner.get_facing_direction().x == -1:
			owner.toggle_flip_h()
		else: 
			owner.toggle_flip_h()
	if not owner.is_on_floor():
		emit_signal("finished", "fall")
		
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_animation_finished(anim_name:String)->void:
	if anim_name == "Squirm":
		emit_signal("finished","idle")
