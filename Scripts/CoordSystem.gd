class_name CoordSystem

const STEP_X = 16
const STEP_Y = 16

static func coord_to_world(coord : Vector2i):
	var world_pos_x = coord.x * STEP_X
	var world_pos_y = coord.y * STEP_Y
	return Vector2(world_pos_x, world_pos_y)
