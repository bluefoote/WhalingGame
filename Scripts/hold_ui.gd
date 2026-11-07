extends Control
class_name HoldUI

func _draw() -> void:
	for i in range(6):
		draw_line(Vector2(i * 32, 0), Vector2(i * 32, 32 * 5), Color.WHITE, 1)
	for i in range(6):
		draw_line(Vector2(0, 0 + i * 32), Vector2(32 * 5, i * 32), Color.WHITE, 1)
	#draw_line(Vector2(15 + 32, 0), Vector2(15 + 32, 32 * 5), Color.WHITE, 1)
		#draw_line(Vector2(15 + x * 32, 0), Vector2(15 + x * 32, y * 32), Color.WHITE, 1)

func _gui_input(event: InputEvent) -> void: ### Eventually get this moved into PlayerInput
	if event is InputEventMouseButton:
		if event.pressed:
			print('clicked')
			### Get which cell of hold was clicked
			print("Hold coord: ", CoordSystem.world_to_coord(event.position))
	elif event is InputEventMouseMotion:
		print("Hold coord: ", CoordSystem.world_to_coord(event.position))
			
func update_hold(hold : Dictionary):
	for key in hold.keys():
		pass
