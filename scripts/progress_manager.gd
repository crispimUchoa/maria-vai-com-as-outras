extends Node

enum Act {
	BEGIN_MARIA_HOUSE,
	BEGIN_GO_TO_SCHOOL,
	DEAD_GIRL_WARNING,
}

const INITIAL_PROGRESS = {
	'current_act': Act.BEGIN_MARIA_HOUSE,
	'current_level': "",
	'current_spawn_id': "",
}

var current_act: Act = Act.BEGIN_MARIA_HOUSE
var current_level: String = ""
var current_spawn_id: String = ""

func set_act(act: Act):
	current_act = act

func get_act():
	return current_act

func is_act(act: Act):
	return current_act == act

func reset_progress():
	current_act = Act.BEGIN_MARIA_HOUSE
	current_level = ""
	current_spawn_id = ""

func load_progress(loaded):
	current_act = loaded["current_act"]
	current_level = loaded["current_level"]
	current_spawn_id = loaded["current_spawn_id"]
