extends Node2D
class_name ShipComponent

### Ship component that handles things like how many moves each day the actor can move
### Holds the crew member objects
### Has food and handles getting more/eating it
### Handles adding and removing crew members

var crew_members : Array[CrewMember] = []
var current_food_stores : int = 100 ### Numerical representation of how much food/water is on the ship in the food storage items in the hold
var max_storage_x : int = 5
var max_storage_y : int = 5
var hold : Dictionary = {} ### Grid that limits items, Vector2i -> HoldItems for now. Might change it to a 1d array eventually.
var items : Array = [] ### List of items to allow for iteration over them

signal ship_stats_changed

func _on_new_day():
	calculate_food_stores()
	var amount_of_food_eaten = 0
	for crew_member in crew_members:
		if current_food_stores > 0:
			if current_food_stores >= crew_member.needs: ### Crew member will be fully satiated
				current_food_stores = max(0, current_food_stores - crew_member.needs)
				crew_member.eat(crew_member.needs)
				amount_of_food_eaten += crew_member.needs
			else:
				crew_member.eat(current_food_stores)
				amount_of_food_eaten += current_food_stores
				current_food_stores = 0
				### Apply remaining food to crew_member here 
			
		else:
			crew_member.eat(0)
	### Reduce the food item with the lowest remaining food and remove empty food items from items and the hold
	ship_stats_changed.emit(self)
	
func calculate_food_stores():
	var food_sum
	for item in items:
		if item
	current_food_stores = food_sum ### Sum of all food items in hold
		
func add_crew_member(new_crew_member : CrewMember):
	crew_members.append(new_crew_member)
