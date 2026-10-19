extends Node

enum Act {
	BEGIN_MARIA_HOUSE,
	BEGIN_GO_TO_SCHOOL
}

var current_act: Act = Act.BEGIN_MARIA_HOUSE
var current_scene: String = ""
var current_spawn_id: String = ""
