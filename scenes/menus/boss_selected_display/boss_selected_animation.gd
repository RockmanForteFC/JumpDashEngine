extends Node2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(String) var boss:String = ""
onready var Timer = $BossTitle/Timer

var _default_background_color:Color = Color("000000")
var _default_grid_color:Color = Color("f878f8")

var _boss_background_color:Color = Color("08314a")
var _boss_grid_color:Color = Color("f89838")

var border_steps: int
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if boss == "":
		boss = PlayerValues.boss_display_name
	if boss == "example_level":
		boss = "unknown"
		_boss_background_color  = Color("42008c")
		_boss_grid_color = Color("00fcfc")
	$Node/BGM.play()
	yield(get_tree().create_timer(1.5),"timeout")
	$CenterBossDisplay/CenterDisplayAnimation.play("open")
	PlayerValues.boss_display_name = ""

	border_steps = 0
	$BorderTimer.connect("timeout", self, "_step_border")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func show_boss():
	$Bosses/IntroPlayer.play("Intro")
	yield($Bosses/IntroPlayer,"animation_finished")
	$Bosses/IntroPlayer.play(boss)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _set_vapor_colors(default_colors:bool = false ):
	if not $vapor_down or not $vapor_up:
		return

	if default_colors:
		$vapor_down.background_color = _default_background_color
		$vapor_down.line_color = _default_grid_color
		$vapor_up.background_color = _default_background_color
		$vapor_up.line_color = _default_grid_color
	else:
		$vapor_down.background_color = _boss_background_color
		$vapor_down.line_color = _boss_grid_color
		$vapor_up.background_color = _boss_background_color
		$vapor_up.line_color = _boss_grid_color
	$vapor_down.set_colors()
	$vapor_up.set_colors()

func _dialogue():
	var boss_name:String = boss
	if boss == "unknown":
		boss_name = "Example Level"

	for letter in boss_name:
		Timer.start()
		if letter == "_":
			letter = " "
		$BossTitle/Label.text += letter
		yield(Timer, "timeout")
#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_animation_finished(anim_name):
	if anim_name == "open":
		show_boss()

func _on_BGM_finished():
	yield(get_tree().create_timer(1.5),"timeout")
	get_tree().change_scene(PlayerValues.last_played_level)

# Steps border position.
func _step_border() -> void:
	$DisplayArea/BorderTop.rect_position.y += 1
	$DisplayArea/BorderBottom.rect_position.y -= 1
	border_steps += 1
	if border_steps >= 20:
		$BorderTimer.stop()
