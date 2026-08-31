extends Label

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const TITLE_OPEN = "[color=#f0b838]『"
const TITLE_CLOSE = "』[/color]\r\n"
#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal label_complete
#-------------------------------------------------
#      Properties
#-------------------------------------------------
export (float, 0.05,1,0.05) var character_delay:float = 0.05
export (String) var speaker:String = ""
export (bool) var play_sound:bool = false
var no_sound_characters = [" ","\r\n","\r","\n"]
export (bool) var pause_on_punctuation:bool = false
var pause_time:float = 0.2
var punctuation = ["."]
var _character_index:int = 0
var final_output:String = ""
var is_running:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pause_time = character_delay * 2
	stop()

	$CharacterDelay.wait_time = character_delay
	$CharacterDelay.connect("timeout",self,"_show_next_character")

func _process(delta):
	if is_running:
		if Input.is_action_just_pressed("action_jump_p1") or Input.is_action_just_pressed("action_shoot_p1") or Input.is_action_just_pressed("ui_accept"):
			stop()
			emit_signal("label_complete")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func start():
	is_running= true
	final_output = tr(text)
	text = ""
	if speaker:
		speaker = TITLE_OPEN + tr(speaker) + TITLE_CLOSE
		$RichTextLabel.bbcode_text  += speaker
	show()
	$CharacterDelay.start()

func stop():
	$CharacterDelay.stop()
	set_process(false)
	$Control/TextureRect.hide()
	hide()
	_character_index = 0
	if is_running:
		speaker = ""
	is_running = false
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _show_next_character():
	if play_sound and !$CharacterSound.playing:
		if !no_sound_characters.has(final_output[_character_index]):
			$CharacterSound.play()
	$RichTextLabel.bbcode_text += final_output[_character_index]
	if pause_on_punctuation:
		if punctuation.has(final_output[_character_index]):
			yield(get_tree().create_timer(pause_time),"timeout")
	_character_index += 1
	if $RichTextLabel.bbcode_text == speaker + final_output:
		$Control/TextureRect.show()
		set_process(true)
	else:
		$CharacterDelay.start()

#-------------------------------------------------
#      Connections
#-------------------------------------------------
