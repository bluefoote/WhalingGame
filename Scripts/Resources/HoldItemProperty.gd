extends Resource
class_name HoldItemProperty

### Superclass for properties of the HoldItem class
### Always use the subclasses

@export var hold_item_property_name : String

#func _notification(what):
	#match what:
		#NOTIFICATION_PREDELETE:
			#print("good-bye") 
