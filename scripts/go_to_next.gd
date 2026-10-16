extends Node2D



@onready var interaction_area = $InteractionArea
@export_file(".tscn") var next_level_file: String
@export var next_spawn_id: String = ""
var can_go: bool = true
var alternative_func: Callable

func _on_interaction_area_interacted() -> void:
	if (!can_go): 
		if (alternative_func):
			alternative_func.call()
		return
	if (next_level_file):
		SceneManager.change_level(next_level_file, next_spawn_id)
	else:
		push_warning("Nenhuma cena destino foi configurada em:", name)
