extends Node

signal level_change_requested(next_level_path: String, next_spawn_id: String)

func change_level(next_level_path: String, next_spawn_id: String) -> void:
	level_change_requested.emit(next_level_path, next_spawn_id)
