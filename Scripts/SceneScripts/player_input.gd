extends Node2D
class_name PlayerInput

signal action_pressed

enum input_mode { WORLD, BATTLE }
var current_input_mode : input_mode = input_mode.WORLD

func _unhandled_input(event: InputEvent) -> void:
	get_viewport().gui_release_focus()
	match current_input_mode:
		input_mode.WORLD:
			if is_move_action(event):
				return 
	
func is_move_action(event : InputEvent):
	for i in InputTag.MOVE_ACTIONS:
		if event.is_action_pressed(i, true):
			action_pressed.emit(i)
			return true
	return false
