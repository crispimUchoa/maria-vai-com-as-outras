extends Node

enum Act {
	BEGIN_MARIA_HOUSE,
	BEGIN_GO_TO_SCHOOL
}

var current_act: Act = Act.BEGIN_MARIA_HOUSE
var current_level: String = ""
var current_spawn_id: String = ""


func reset_progress():
	current_act = Act.BEGIN_MARIA_HOUSE
	current_level = ""
	current_spawn_id = ""
