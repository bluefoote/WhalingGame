class_name CoordSystem

const STEP_X = 16
const STEP_Y = 16

static func coord_to_world(coord : Vector2i):
	var world_pos_x = coord.x * STEP_X
	var world_pos_y = coord.y * STEP_Y
	return Vector2(world_pos_x, world_pos_y)
	
static func world_to_coord(world_pos : Vector2i):
	var coord_x = floori(world_pos.x / 32)
	var coord_y = floori(world_pos.y / 32)
	return Vector2i(coord_x, coord_y)
