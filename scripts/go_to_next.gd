extends Node2D

@onready var interaction_area = $InteractionArea
@export_file(".tscn") var target_scene: String

func _on_interaction_area_interacted() -> void:
	if (target_scene):
		get_tree().change_scene_to_file(target_scene)
	else:
		push_warning("Nenhuma cena destino foi configurada em:", name)
