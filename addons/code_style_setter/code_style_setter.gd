tool
extends EditorPlugin

# This plugin updates global editor settings automatically to conform with
# project style requirements.


func _enter_tree() -> void:
	var editor_config = get_editor_interface().get_editor_settings()

	if editor_config.has_setting("text_editor/indent/type"):
		# set indentation type to tabs
		editor_config.set_setting("text_editor/indent/type", 0)

	if editor_config.has_setting("text_editor/indent/convert_indent_on_save"):
		# convert indentation to spaces on save
		editor_config.set_setting("text_editor/indent/convert_indent_on_save", true)

func _exit_tree():
	pass
