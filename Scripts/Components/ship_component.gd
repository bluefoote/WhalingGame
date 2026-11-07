extends Node2D
class_name ShipComponent

### Ship component that handles things like how many moves each day the actor can move
### Holds the crew member objects
### Has food and handles getting more/eating it
### Handles adding and removing crew members

var crew_members : Array[CrewMember] = []
var current_food_stores : int = 0 ### Numerical representation of how much food/water is on the ship in the food storage items in the hold
var max_storage_x : int = 5
var max_storage_y : int = 5
var hold : Dictionary = {} ### Grid that limits items, Vector2i -> HoldItems for now. Might change it to a 1d array eventually.
var items : Array = [] ### List of items to allow for iteration over them

signal ship_stats_changed

func _ready():
	for y in range(max_storage_y):
		for x in range(max_storage_x):
			hold[Vector2i(x, y)] = null

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
	decrement_food(amount_of_food_eaten)
	print("Food eaten: ", amount_of_food_eaten)
	ship_stats_changed.emit(self)
	
func calculate_food_stores():
	var food_sum = 0
	for item in items:
		if item.has_property("Food"):
			food_sum += item.get_property("Food").food_amount
	current_food_stores = food_sum ### Sum of all food items in hold
	
func decrement_food(amount : int):
	while amount > 0:
		var lowest_food_amount = INF
		var lowest_food_amount_item
		for item in items:
			if item.has_property("Food"):
				if item.get_property("Food").food_amount < lowest_food_amount:
					lowest_food_amount = item.get_property("Food").food_amount
					lowest_food_amount_item = item
		if amount >= lowest_food_amount: ### Remove item
			amount = max(0, amount - lowest_food_amount)
			remove_item(lowest_food_amount_item)
		else: ### Decrement food item
			lowest_food_amount_item.get_property("Food").food_amount = max(0, lowest_food_amount_item.get_property("Food").food_amount - amount)
			amount = 0

func add_item(new_hold_item : HoldItem):
	items.append(new_hold_item)
	if hold_has_empty_space(): ### Eventually this should be smarter, pass the new_hold_item size and check if it can fit but for now, all items are 1x1
		hold[get_first_empty_space_in_hold()] = new_hold_item
	### TODO: Add the item to the hold. Create the visual representation 
	
func hold_has_empty_space() -> bool:
	for y in range(max_storage_y):
		for x in range(max_storage_x):
			if hold[Vector2i(x, y)] == null:
				return true
	return false
	
func get_first_empty_space_in_hold():
	for y in range(max_storage_y):
		for x in range(max_storage_x):
			if hold[Vector2i(x, y)] == null:
				return Vector2i(x, y)
	return Vector2i(-1, -1)
	
func remove_item(item : HoldItem):
	items.erase(item)
		
func add_crew_member(new_crew_member : CrewMember):
	crew_members.append(new_crew_member)
