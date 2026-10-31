extends Node2D
class_name Actor

### The movable object within the game world. i.e. a ship or a sea monster, etc
### This object should just handle having a name and a coord.
### Actually game info/logic should be handled by composed child nodes.

var coord : Vector2i 
var actor_name : String

signal died ### Signal to remove this

func set_coord(new_coord):
	coord = new_coord
	position = CoordSystem.coord_to_world(coord)
	print(coord)

func _on_new_day():
	for child in get_children():
		if child.has_method("_on_new_day"):
			child._on_new_day()
