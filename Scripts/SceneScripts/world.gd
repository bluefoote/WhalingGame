extends Node2D
class_name World

### Manages setup of signal connections
### Has debug mode to start game

@onready var actor_manager = $ActorManager
@onready var player_input = $PlayerInput
@onready var map_manager = $MapManager
@onready var turn_manager = $TurnManager

@onready var ship_stores_test_ui = $UI/TestUI/ShipStoresTest
@onready var crew_member_info_test = $UI/TestUI/CrewMemberInfo

var day = 0

func _ready() -> void:
	if get_tree().current_scene == self: ### Standalone test
		### Spawn player actor
		### Generate hard coded map from data file
		### Connect player input to allow player actor to move around game world
		### Setup TurnManager to allow for 
		var actor_scene = load("res://Scenes/actor.tscn")
		var actor_instance = actor_scene.instantiate()
		actor_manager.add_child(actor_instance)
		actor_instance.set_coord(Vector2i(0, 0))
		actor_instance.actor_name = "pc"
		actor_instance.add_to_group("PlayerCharacter")
		var ship_component_scene = load("res://Scenes/ship_component.tscn")
		var ship_component_instance = ship_component_scene.instantiate()
		actor_instance.add_child(ship_component_instance)
		var generic_crew_member = load("res://Resources/CrewMembers/GenericCrewman.tres").duplicate()
		generic_crew_member.crew_member_name = "Murray"
		ship_component_instance.add_crew_member(generic_crew_member)
		actor_manager.set_pc(actor_instance)
		turn_manager._on_Actor_Spawn(actor_instance, 0)
		
		### DEBUG
		generic_crew_member.crew_member_stats_changed.connect(set_crew_member_test_info.bind(ship_component_instance))
		ship_component_instance.ship_stats_changed.connect(set_ship_stores_test_ui)
		turn_manager.player_time_changed.connect(set_time_left_in_day_test)
		set_crew_member_test_info(ship_component_instance)
		set_ship_stores_test_ui(ship_component_instance)
		set_day_counter_test()
		set_time_left_in_day_test(0)
		
		connect_nodes()
		turn_manager.get_next_event() ### Start
		
func connect_nodes():
	player_input.action_pressed.connect(actor_manager._on_Player_turn_choice)
	actor_manager.map = map_manager
	turn_manager.player_action_taken.connect(_on_player_turn_taken)
	turn_manager.player_turn_started.connect(_on_player_turn_start)
	actor_manager.action_taken.connect(turn_manager._on_action_taken)
	turn_manager.new_day_started.connect(set_day_counter_test)

func _on_player_turn_taken():
	player_input.set_process_unhandled_input(false)
	
func _on_player_turn_start():
	player_input.set_process_unhandled_input(true)

func set_crew_member_test_info(ship_component : ShipComponent):
	var text = ""
	for crew_member in ship_component.crew_members:
		text = crew_member.crew_member_name + ", Strength: " + str(crew_member.strength) + ", Needs: " + str(crew_member.needs) + "\n"
	crew_member_info_test.text = text
	
func set_ship_stores_test_ui(ship_component : ShipComponent):
	ship_stores_test_ui.text = "Ship stores: " + str(ship_component.food_stores)

func set_day_counter_test():
	$UI/TestUI/DayCounter.text = "Day: " + str(day)
	day += 1

func set_time_left_in_day_test(time_used):
	var time_left = 100 - time_used
	$UI/TestUI/TimeLeftInDay.text = "Time left in day: " + str(time_left) + "%"
