extends Node2D
class_name MapManager

var map_data : MapData

func _ready() -> void:
	### Load hardcoded map
	map_data = MapData.new()
	
func _exit_tree() -> void:
	map_data.free()

func is_coord_open(coord : Vector2i):
	return map_data.is_coord_open(coord)
