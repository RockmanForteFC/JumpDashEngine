tool
extends Node2D

class_name YokuBlock

export(int, 1, 10) var index := 1 setget _set_index
export(bool) var show_index := false setget _show_index
export(String, "gladiator","endless","challenge","virus_1") var texture:String = "gladiator"

func _ready() -> void:
	if texture == "gladiator":
		$Sprite.texture = load("res://assets/images/sprites/yoku/gladiator_yoku.png")
	elif texture == "endless":
		$Sprite.texture = load("res://assets/images/sprites/yoku/endless_yoku.png")
	elif texture == "virus_1":
		$Sprite.texture = load("res://assets/images/sprites/yoku/virus_fortress_1_yoku.png")
	if Engine.editor_hint:
		$Debug_Sprite.visible = true
	elif not Engine.editor_hint:
		$Sprite.visible = false
		$Debug_Sprite.visible = false
		$PreciseVisibilityNotifier2D.connect("camera_entered", self, "_on_camera_entered")

func appear() -> void:
	$AnimationPlayer.play("Appear")

func is_on_screen() -> bool:
	return $PreciseVisibilityNotifier2D.is_on_screen()

func _on_camera_entered() -> void:
	get_parent().set_active()

func _set_index(value: int) -> void:
	$Label.text = str(value)
	index = value

func _show_index(value: bool) -> void:
	$Label.text = str(index)
	$Label.visible = value
	show_index = value
