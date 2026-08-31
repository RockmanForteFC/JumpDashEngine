extends Label

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const TITLE_OPEN = "『"
const TITLE_CLOSE = "』\r\n"
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
export (float) var wait_time:float = 2.0
var pause_time:float = 0.2
var punctuation = ["."]
var _character_index:int = 0
var final_output:String = ""
var is_running:bool = false
var did_stop:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pause_time = character_delay * 2
	stop()
	$CharacterDelay.wait_time = character_delay
	$CharacterDelay.connect("timeout",self,"_show_next_character")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func start():
	is_running= true
	final_output = text
	text = ""
	if speaker:
		speaker = TITLE_OPEN + speaker + TITLE_CLOSE
		text += speaker
		$Speaker.show()
	show()
	$CharacterDelay.start()

func stop():
	$CharacterDelay.stop()
	set_process(false)
	$Control/TextureRect.hide()
	hide()
	_character_index = 0
	if is_running:
		$Speaker.hide()
		speaker = ""
	is_running = false
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _show_next_character():
	if play_sound and !$CharacterSound.playing:
		if !no_sound_characters.has(final_output[_character_index]):
			$CharacterSound.play()
	text += final_output[_character_index]
	if pause_on_punctuation:
		if punctuation.has(final_output[_character_index]):
			yield(get_tree().create_timer(pause_time),"timeout")
	_character_index += 1
	if text == speaker + final_output:
		yield(get_tree().create_timer(wait_time),"timeout")
		emit_signal("label_complete")
		stop()
	else:
		$CharacterDelay.start()

#-------------------------------------------------
#      Connections
#-------------------------------------------------
