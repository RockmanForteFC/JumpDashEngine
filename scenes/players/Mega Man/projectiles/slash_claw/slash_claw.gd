extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

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
	$AnimationPlayer.play("slash")
	$Slash.play()
	if direction.x < 0:
		$Sprite.flip_h = true

		
func _physics_process(delta):
	if direction.x < 0:
		global_position.x = PlayerValues.player.global_position.x - 10
	else:
		global_position.x = PlayerValues.player.global_position.x + 10
	global_position.y = PlayerValues.player.global_position.y + 4

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	hide()
	consumed = true
	.queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("SlashClawP1"):
		remove_from_group("SlashClawP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ("slash"):
		queue_free()
