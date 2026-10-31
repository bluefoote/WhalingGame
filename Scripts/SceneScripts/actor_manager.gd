extends Node2D
class_name ActorManager

var pc : Actor
var map : MapManager

signal action_taken

func set_pc(pc_actor : Actor):
	pc = pc_actor

func _on_Player_turn_choice(action : StringName):
	match action:
		"move_up":
			move_pc(Vector2.UP)
		"move_down":
			move_pc(Vector2.DOWN)
		"move_left":
			move_pc(Vector2.LEFT)
		"move_right":
			move_pc(Vector2.RIGHT)
			
func move_pc(dir : Vector2i):
	var attempted_coord = pc.coord + dir
	### Check if run into another actor == encounter
	### else check if map has spot
	if map.is_coord_open(attempted_coord):
		var old_coord = pc.coord
		pc.set_coord(attempted_coord)
		action_taken.emit(25)
		
