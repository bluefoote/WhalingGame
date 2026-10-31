extends Object
class_name MapData

### Object that holds all MapData info
### This should be hard coded to start and then eventually proc gen but c'mon let's be real, this game is never getting finished

const MAP_SIZE_X = 16
const MAP_SIZE_Y = 16

func is_coord_open(coord : Vector2i):
	if coord.x >= 0 and coord.x < MAP_SIZE_X and coord.y >= 0 and coord.y < MAP_SIZE_Y:
		return true
	return false
