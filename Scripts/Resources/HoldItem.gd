extends Resource
class_name HoldItem

### Basic class for Items stored in the Hold, as opposed to Items equipped to CrewMembers.
### All HoldItems have a name and a 2d size
### HoldItems have an array of Property resources that define what the item does, i.e. is food, remains of a sea monster, treasure

@export var item_name : String
@export var item_size : Vector2i

@export var item_properties : Array[HoldItemProperty]

func has_property(property_name : String):
	for item_property in item_properties:
		if item_property.hold_item_property_name == property_name:
			return true
	return false
	
func get_property(property_name : String):
	for item_property in item_properties:
		if item_property.hold_item_property_name == property_name:
			return item_property
	return null
	
#func _notification(what):
	#match what:
		#NOTIFICATION_PREDELETE:
			#print("good-bye") 
