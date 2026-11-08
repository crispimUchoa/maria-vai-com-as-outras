extends Node

signal mission_requested
signal change_acess_requested

enum Act {
	BEGIN_MARIA_HOUSE,
	BEGIN_GO_TO_SCHOOL,
	DEAD_GIRL_WARNING,
	ESPOCA_BUCHO
}

enum Action {
	MERENDAR_COM_A_VO_NO_COMECO,
	PEDIR_BENCA_PRO_PAI_NO_COMECO,
}

var actions: Array[Action] = []

const INITIAL_PROGRESS = {
	'current_act': Act.BEGIN_MARIA_HOUSE,
	'current_level': "",
	'current_spawn_id': "",
	'merendou': false,
	'actions': []
}


var current_act: Act = Act.BEGIN_MARIA_HOUSE
var current_level: String = ""
var current_spawn_id: String = ""
var merendou: bool = false
var mission = "Vá merendar"

func set_act(act: Act):
	current_act = act
	change_acess_requested.emit()

func get_act():
	return current_act

func is_act(act: Act):
	return current_act == act

func reset_progress():
	current_act = Act.BEGIN_MARIA_HOUSE
	current_level = "res://scenes/PlayerBedRoom.tscn"
	current_spawn_id = "InitialSpawn"
	merendou = false
	actions = []

func load_progress(loaded):
	current_act = loaded["current_act"]
	current_level = loaded["current_level"]
	current_spawn_id = loaded["current_spawn_id"]
	merendou = loaded.get("merendou", false)
	actions = loaded.get("actions", [] as Array[Action])

func save_progress() -> Dictionary:
	return {
		"current_act": current_act,
		"current_level": current_level,
		"current_spawn_id": current_spawn_id,
		"merendou": merendou,
		"actions": actions
	}

func set_mission(new_mission: String):
	mission = new_mission
	mission_requested.emit(new_mission)

func has_action(action: Action):
	return action in actions

func do_action(action: Action):
	if (!has_action(action)):
		actions.append(action)
