extends Node2D
class_name TurnManager

var turn_events : Array[TimeEvent] = []
var current_event : TimeEvent

var actors ### Actors or Actors2D
var map : MapManager
var game_over : bool = false
var victory : bool = false

signal player_action_taken
signal player_turn_started
signal changed_actor_focus
signal action_logged
signal update_turn_ui
signal new_day_started ### Signal for general world handling stuff
signal player_time_changed

signal game_over_signal

func _ready():
	var new_turn_event = TimeEvent.new()
	new_turn_event.time = 100
	new_turn_event.event_obj = self
	insert_event(new_turn_event)
	
func _on_Actor_Spawn(new_actor: Actor, start_time : int = 100):
	var event = TimeEvent.new()
	new_actor.died.connect(_on_Remove_Actor.bind(event))
	event.event_obj = new_actor
	if new_actor.is_in_group("NPC"):
		event.time = start_time
	insert_event(event)
	
func _on_action_taken(action_time : int): 
	var is_player_action = false
	if current_event != null:
		if current_event.event_obj.is_in_group("PlayerCharacter"):
			is_player_action = true
		current_event.time += action_time
		current_event.event_obj.remove_from_group("CurrentTurn")
		insert_event(current_event)
	if is_player_action:
		player_action_taken.emit()
		player_time_changed.emit(current_event.time)
	#print("get next action")
	await get_tree().create_timer(0.05).timeout
	(func() : get_next_event()).call_deferred()
	
func insert_object(obj : Object, start_time : int = 100):
	var event = TimeEvent.new()
	obj.died.connect(_on_Remove_Actor.bind(event))
	event.event_obj = obj
	if obj.is_in_group("NPC"):
		event.time = start_time
	insert_event(event)

func insert_event(new_event : TimeEvent):
	if turn_events.has(new_event):
		print("uh oh")
	turn_events.push_back(new_event)
	turn_events.sort_custom(sort_array)
	print_turn_events()

func print_turn_events():
	var string = "["
	for event in turn_events:
		string += "("
		if event.event_obj is Actor:
			string += event.event_obj.actor_name
		else:
			string += "Turn"
		string += ", "
		string += str(event.time)
		string += "), "
		
	string += "]"
	print("TurnManager:")
	print("----------------")
	print(string)
	print("")

func get_next_event():
	if !game_over and !victory:
		current_event = turn_events.pop_front()
		if current_event.event_obj == self: ### Start a new turn and decrement all actions by 100
			on_new_turn()
		elif current_event != null:
			if current_event.event_obj is Actor:
#				print(current_event.event_obj.get_groups())
				if current_event.event_obj.is_in_group("PlayerCharacter"):
					player_turn_started.emit()
				else:
					actors._on_NPC_turn_start(current_event.event_obj)
					changed_actor_focus.emit(current_event.event_obj)
				update_turn_ui.emit(current_event, turn_events)
	elif game_over:
		action_logged.emit("Game Over")
		print("Game over")
		game_over_signal.emit()

func on_new_turn():
	if current_event != null:
		for event in turn_events:
			event.time -= 100
			### Unless it is the turn event
			if event.event_obj is Actor:
				event.event_obj._on_new_day()
		insert_event(current_event)
	new_day_started.emit()
	player_time_changed.emit(0)
	turn_events.sort_custom(sort_array)
	call_deferred("get_next_event")

func sort_array(this_element : TimeEvent, that_element : TimeEvent):
	return this_element.time < that_element.time
	
func _on_Remove_Actor(_val : bool, event : TimeEvent):
	if event.event_obj is Actor:
		if current_event != null:
			if current_event.event_obj == event.event_obj:
				current_event = null
		turn_events.erase(event)
		
		if event.event_obj.is_in_group("PlayerCharacter") and get_tree().get_nodes_in_group("PlayerCharacter").size() == 1:
			game_over = true
			print("game over")
		#elif event.event_obj.is_in_group("NPC") and  get_tree().get_nodes_in_group("NPC").size() == 1:
			#print("victory")
			#victory = true
		event.free()
	else:
		turn_events.erase(event)
		event.free()
	#print_turn_events()

func _remove_event_by_object(obj : Object):
	var event_to_remove = null
	for event in turn_events:
		if event.event_obj == obj:
			event_to_remove = event
			
	if event_to_remove != null:
		turn_events.erase(event_to_remove)
		event_to_remove.free()
	#print_turn_events()
