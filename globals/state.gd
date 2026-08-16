# Based on Nathan Lovato's tutorial:
# https://github.com/GDquest/Godot-engine-tutorial-demos/blob/master/2018/04-24-finite-state-machine/player/states/state.gd

extends Node

# Base class for a state machine state.
class_name State

# warning-ignore:unused_signal
signal finished(next_state_name)

func _enter() -> void:
	return

func _exit() -> void:
	return
#warning-ignore:unused_argument
func _handle_input(event: InputEvent) -> void:
	return
#warning-ignore:unused_argument
func _update(delta: float) -> void:
	return
#warning-ignore:unused_argument
func _on_animation_finished(anim_name: String) -> void:
	return
