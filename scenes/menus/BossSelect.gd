extends Node2D
#warning-ignore-all:return_value_discarded


const MENU = "res://scenes/menus/existing_game_menu/existing_game_menu.tscn"
const LETTER_TEXTURE_MASK: String = "res://assets/images/sprites/pickups/letters/letter_%s.png"

# a list of boss names. this will be used to determine if a boss is cleared
var boss_names:Array = ["example_level","a_man","b_woman","c_man","d_man","e_man", "f_man","g_man","h"]
enum boss{incinerate,tremor,maelstrom,ninja,beam,gladiator,arctic,detonate,serenade}

const positions = [
	#top row
	Vector2(64,32),
	Vector2(128,32),
	Vector2(192,32),

	#middle row
	Vector2(64,96),
	Vector2(128,96),
	Vector2(192,96),

	#bottom row
	Vector2(64,160),
	Vector2(128,160),
	Vector2(192,160),

	#shop icon
	Vector2(128,212)
]

enum POS {TL,TM,TR,LM,MM,RM,BL,BM,BR,SHOP}
var selected = POS.MM
var was_position_changed = false
var is_shop_highlighted = false
var is_accepting_inputs = false
var beat_level_count = 0
var selected_middle = ""

# tables containing stage ID & path to stage scene
const STAGES = {
	POS.TL: null,
	POS.TM: null,
	POS.TR: null,
	POS.LM: null,
	POS.MM: null,
	POS.RM: {"id": "example_level", "scene": "res://scenes/stages/levels/example_1/example_1.tscn"},
	POS.BL: null,
	POS.BM: null,
	POS.BR: null,
	"bonus": null
}

onready var _eye_location = $Boss_Layer/BossImages/Eye_Location

func _init():
	# add custom stage IDs to beat levels registry
	for pos in STAGES:
		var stage = STAGES[pos]
		if stage and not stage.id in PlayerValues.beat_levels:
			PlayerValues.beat_levels[stage.id] = false

func _ready():
	PlayerValues.newly_obtained_weapon_name = ""
	beat_level_count = 0
	var levels = PlayerValues.beat_levels.duplicate()
	levels.erase("serenade")
	for l in levels.values():
		if l == true:
			beat_level_count += 1
	if PlayerValues.is_serenade_unlocked:
		selected_middle = "s"
	if beat_level_count == 8:
		if !PlayerValues.is_eight_boss_cutscene_seen:
			selected_middle = "v"
		else:
			selected_middle = "dw"

	# stage select is disabled, they need to go straight to the virus fortress
	if beat_level_count == 8 and (PlayerValues.is_eight_boss_cutscene_seen and PlayerValues.is_in_virus_fortress):
		get_tree().change_scene("res://scenes/cut_scene/virus_fortress_map/virus_fortress_map.tscn")
	$Boss_Layer/BossLabels/Middle.hide()
	$left_arrow.play("nothing")
	$right_arrow.play("nothing")
	$Animate_Shop_Icon.play("ShopFlash")
	PlayerValues.player = null
	PlayerValues.last_played_level = ""
	$CanvasLayer/AnimationPlayer.play("Open_Transition")
	##Sets up the session Timer
	PlayerValues.start_game_timer()
	##updates the global timer
	$AnimationPlayer.play("Shine")
#	$StageSelectFlash.play("Stage_Select")
	$SelectedMenuObject.position = positions[selected]
	_get_eye_location()
	hide_beat_bosses()
	Config.save_config()

func _process(_delta):
	_get_eye_location()
	if Input.is_action_just_pressed("ui_up") and is_accepting_inputs:
		if selected == 9:
			$SelectedMenuObject.hide()
			selected = 7
			is_shop_highlighted = false
			was_position_changed = true
			$AnimationPlayer.play("Shine")
			yield($SelectedMenuObject,"texture_changed")
			$SelectedMenuObject.show()
		else:
			selected -= 3
			if selected < 0:
				selected += 9
			was_position_changed = true
	elif Input.is_action_just_pressed("ui_right") and is_accepting_inputs:
		if not is_shop_highlighted:
			if selected == POS.TR or selected == POS.RM or selected == POS.BR:
				selected -=2
			else:
				selected += 1
			was_position_changed = true
		else:
			pass
	elif Input.is_action_just_pressed("ui_left") and is_accepting_inputs:
		if not is_shop_highlighted:
			if selected == POS.TL or selected == POS.LM or selected == POS.BL:
				selected +=2
			else:
				selected -= 1
			was_position_changed = true
		else:
			pass
	elif Input.is_action_just_pressed("ui_down") and is_accepting_inputs:
		selected += 3
		if selected >= 9 and not is_shop_highlighted:
			$SelectedMenuObject.hide()
			selected = 9
			is_shop_highlighted = true
			$AnimationPlayer.play("Shine_Shop")
			yield($SelectedMenuObject,"texture_changed")
			$SelectedMenuObject.show()
		elif selected > 9 and is_shop_highlighted:
			$SelectedMenuObject.hide()
			selected = 1
			is_shop_highlighted = false
			$AnimationPlayer.play("Shine")
			yield($SelectedMenuObject,"texture_changed")
			$SelectedMenuObject.show()
		was_position_changed = true
	if was_position_changed:
		$Switch.play()
		was_position_changed = false
		$SelectedMenuObject.position = positions[selected]
	if (Input.is_action_just_pressed("action_left_swap_p1") or Input.is_action_just_pressed("action_right_swap_p1")):
		if selected == POS.MM:
			if selected_middle == "s":
				if PlayerValues.is_in_wily_fortress and beat_level_count == 8  :
					selected_middle = "dw"
				elif !PlayerValues.is_in_virus_fortress and beat_level_count == 8  :
					selected_middle = "v"
			elif selected_middle != "s" and PlayerValues.is_serenade_unlocked :
				selected_middle = "s"
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("action_jump_p1")) and is_accepting_inputs:
		if (selected in STAGES and STAGES[selected] != null) or is_shop_highlighted:
			is_accepting_inputs = false
			$ColorRect.show()
			$SelectedMenuObject.hide()
			$shop_icon.hide()
			set_process(false)
#			$StageSelectFlash.play("RESET")
			if not is_shop_highlighted:
				_eye_location.play("Determined")
			else:
				_eye_location.play("Happy")
			$AnimationPlayer.play("Flash_Screen")
			$Boss_Select.play()
		elif selected == POS.MM:
			if PlayerValues.is_serenade_unlocked and selected_middle == "s":
				is_accepting_inputs = false
				$ColorRect.show()
				$SelectedMenuObject.hide()
				$shop_icon.hide()
				set_process(false)
				_eye_location.play("Determined")
				$AnimationPlayer.play("Flash_Screen")
				$Boss_Select.play()
			elif beat_level_count == 8 and selected_middle == "dw":
				is_accepting_inputs = false
				$ColorRect.show()
				$SelectedMenuObject.hide()
				$shop_icon.hide()
				set_process(false)
				_eye_location.play("Determined")
				$AnimationPlayer.play("Flash_Screen")
				$Boss_Select.play()
				pass
			else:
				$Error.play()
		else:
			$Error.play()

func _get_eye_location():
	$Boss_Layer/BossLabels/Middle.hide()
	$Boss_Layer/scanlines/Mid_Mid.hide()
	match selected:
		POS.TL:
			_eye_location.play("UpLeft")
			$left_arrow.play("nothing")
			$right_arrow.play("nothing")
		POS.TM:
			_eye_location.play("Up")
			$left_arrow.play("nothing")
			$right_arrow.play("nothing")
		POS.TR:
			_eye_location.play("UpRIght")
			$left_arrow.play("nothing")
			$right_arrow.play("nothing")
		POS.LM:
			_eye_location.play("Left")
			$left_arrow.play("nothing")
			$right_arrow.play("nothing")
		POS.MM:
			if beat_level_count == 8 or PlayerValues.is_serenade_unlocked:
				if beat_level_count == 8 and PlayerValues.is_serenade_unlocked:
					$left_arrow.play("flash")
					$right_arrow.play("flash")
					$Boss_Layer/BossLabels/Middle.show()
				if selected_middle == "v":
					_eye_location.play("Miss_Wily")
					$Boss_Layer/scanlines/Mid_Mid.hide()
				elif selected_middle == "dw":
					_eye_location.play("Doctor_Wily")
					$Boss_Layer/scanlines/Mid_Mid.hide()
				elif selected_middle == "s":
					if STAGES.bonus and PlayerValues.is_serenade_unlocked:
						if PlayerValues.beat_levels[STAGES.bonus.id]:
							_eye_location.play("Serenade_Defeated")
							$Boss_Layer/scanlines/Mid_Mid.show()
						else:
							$Boss_Layer/scanlines/Mid_Mid.hide()
							_eye_location.play("Serenade")
			else:
				_eye_location.play("Middle")
				$Boss_Layer/scanlines/Mid_Mid.hide()
		POS.RM:
			_eye_location.play("Right")
			$left_arrow.play("nothing")
			$right_arrow.play("nothing")
		POS.BL:
			_eye_location.play("DownLeft")
			$left_arrow.play("nothing")
			$right_arrow.play("nothing")
		POS.BM:
			_eye_location.play("Down")
			$left_arrow.play("nothing")
			$right_arrow.play("nothing")
		POS.BR:
			_eye_location.play("DownRight")
			$left_arrow.play("nothing")
			$right_arrow.play("nothing")

	if is_shop_highlighted:
		_eye_location.play("Shop")
		$left_arrow.play("nothing")
		$right_arrow.play("nothing")

func hide_beat_bosses():
	if PlayerValues.beat_levels[boss_names[boss.incinerate]]:
		$Boss_Layer/BossLabels/Mid_Right.modulate = Color("bfb3b3")
		$Boss_Layer/BossImages/Mid_Right.texture = load("res://assets/images/sprites/menus/beat_bosses/incinerate.png")
		$Boss_Layer/scanlines/Mid_Right.show()

	if PlayerValues.beat_levels[boss_names[boss.tremor]]:
		$Boss_Layer/BossLabels/Bottom_Right.modulate = Color("bfb3b3")
		$Boss_Layer/BossImages/Bottom_Right.texture = load("res://assets/images/sprites/menus/beat_bosses/tremor.png")
		$Boss_Layer/scanlines/Bottom_Right.show()

	if PlayerValues.beat_levels[boss_names[boss.maelstrom]]:
		$Boss_Layer/BossLabels/Bottom_Left.modulate = Color("bfb3b3")
		$Boss_Layer/BossImages/Bottom_Left.texture = load("res://assets/images/sprites/menus/beat_bosses/maelstrom.png")
		$Boss_Layer/scanlines/Bottom_Left.show()

	if PlayerValues.beat_levels[boss_names[boss.ninja]]:
		$Boss_Layer/BossLabels/Top_Right.modulate = Color("bfb3b3")
		$Boss_Layer/BossImages/Top_Right.texture = load("res://assets/images/sprites/menus/beat_bosses/ninja.png")
		$Boss_Layer/scanlines/Top_Right.show()

	if PlayerValues.beat_levels[boss_names[boss.beam]]:
		$Boss_Layer/BossLabels/Top_Middle.modulate = Color("bfb3b3")
		$Boss_Layer/BossImages/Top_Middle.texture = load("res://assets/images/sprites/menus/beat_bosses/beam.png")
		$Boss_Layer/scanlines/Top_Middle.show()

	if PlayerValues.beat_levels[boss_names[boss.gladiator]]:
		$Boss_Layer/BossLabels/Top_Left.modulate = Color("bfb3b3")
		$Boss_Layer/BossImages/Top_Left.texture = load("res://assets/images/sprites/menus/beat_bosses/gladiator.png")
		$Boss_Layer/scanlines/Top_Left.show()

	if PlayerValues.beat_levels[boss_names[boss.arctic]]:
		$Boss_Layer/BossLabels/Bottom_Middle.modulate = Color("bfb3b3")
		$Boss_Layer/BossImages/Bottom_Middle.texture = load("res://assets/images/sprites/menus/beat_bosses/arctic.png")
		$Boss_Layer/scanlines/Bottom_Middle.show()

	if PlayerValues.beat_levels[boss_names[boss.detonate]]:
		$Boss_Layer/BossLabels/Mid_Left.modulate = Color("bfb3b3")
		$Boss_Layer/BossImages/Mid_Left.texture = load("res://assets/images/sprites/menus/beat_bosses/detonate.png")
		$Boss_Layer/scanlines/Mid_Left.show()


func loadStage():
	$CanvasLayer/AnimationPlayer.play("Close_Transition")
	yield($CanvasLayer/AnimationPlayer,"animation_finished")

	var stage = STAGES[selected] if selected in STAGES else null
	if stage:
		PlayerValues.last_played_level = stage.scene
		PlayerValues.boss_display_name = stage.id
		PlayerValues.refill_everything()
		if not PlayerValues.beat_levels[stage.id]:
			get_tree().change_scene("res://scenes/menus/boss_selected_display/boss_selected_animation.tscn")
		else:
			get_tree().change_scene(stage.scene)
	elif selected == POS.MM:
		if selected_middle == "v" or not STAGES.bonus:
			pass
		elif selected_middle == "dw":
			PlayerValues.boss_display_name = STAGES.bonus.id
			get_tree().change_scene("res://scenes/cut_scene/wily_fortress_map/wily_fortress.tscn")
		elif selected_middle == "s":
			if PlayerValues.is_serenade_unlocked:
				PlayerValues.last_played_level = STAGES.bonus.scene
				PlayerValues.boss_display_name = STAGES.bonus.id
				PlayerValues.refill_everything()
				if not PlayerValues.beat_levels[STAGES.bonus.id]:
					get_tree().change_scene("res://scenes/menus/boss_selected_display/boss_selected_animation.tscn")
				else:
					get_tree().change_scene(STAGES.bonus.scene)
	elif is_shop_highlighted:
		PlayerValues.last_played_level = "existing_game_menu"
		get_tree().change_scene(MENU)

func _on_transition_animation(anim_name):
	if anim_name == "Open_Transition":
		is_accepting_inputs = true
