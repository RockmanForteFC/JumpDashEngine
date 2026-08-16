extends Node

class_name StageMusic
#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal stage_clear_finish_warp_out
signal challenge_clear_warp_out
signal midboss_died
#-------------------------------------------------
#      Properties
#-------------------------------------------------
# var _playback_pos: float = 0.0
var _current_track: AudioStreamPlayer
#-------------------------------------------------
#      Processes
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _ready():
	pause_mode = PAUSE_MODE_PROCESS
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_restarted() -> void:
	if _current_track:
		_current_track.bus = "Music"
	_current_track = $BGM
	_current_track.play()

func on_died() -> void:
	if _current_track != null:
		_current_track.stop()

func on_game_paused() -> void:
	if _current_track and _current_track.playing:
		_current_track.bus = "Pause"

func on_game_resumed() -> void:
	if _current_track and _current_track.playing:
		_current_track.bus = "Music"

func on_boss_entered() -> void:
	_current_track.stop()
	
func on_boss_ready() -> void:
	_current_track.stop()
	_current_track = $BossMusicIntro
	_current_track.play()

func on_boss_died() -> void:
	if _current_track and _current_track.playing:
		_current_track.stop()
	_current_track = $StageClear
	yield(get_tree().create_timer(3.0), "timeout")
	_current_track.play()
	yield(_current_track, "finished")
	_current_track.stop()
	emit_signal("stage_clear_finish_warp_out")

func _on_orb_collected() ->void:
	if _current_track and _current_track.playing:
		_current_track.stop()
	_current_track = $StageClear
	yield(get_tree().create_timer(0.5), "timeout")
	_current_track.play()
	yield(_current_track, "finished")
	_current_track.stop()
	emit_signal("stage_clear_finish_warp_out")

func _on_challenge_teleporter_touched()->void:
	if _current_track and _current_track.playing:
		_current_track.stop()
	_current_track = $StageClear
	yield(get_tree().create_timer(0.5	), "timeout")
	_current_track.play()
	yield(_current_track, "finished")
	_current_track.stop()
	emit_signal("challenge_clear_warp_out")

func _on_BossMusicIntro_finished():
	_current_track = $BossMusic
	_current_track.play()

func dialog_start():
	_current_track = $Dialog
	_current_track.play()
