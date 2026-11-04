extends Node2D

@onready var interaction_area = $InteractionArea
@onready var door_locked: AudioStreamPlayer  = $DoorLocked

@export_file(".tscn") var next_level_file: String
@export var next_spawn_id: String = ""
@export var can_go: bool = true

var alternative_func: Callable

func _on_interaction_area_interacted() -> void:
	if not can_go: 
		if alternative_func and alternative_func.is_valid():
			if not DialogManager.is_open():
				door_locked.play()
			alternative_func.call()
		return
	
	trocar_de_fase()
	
func trocar_de_fase() -> void:
	if next_level_file:
		SceneManager.change_level(next_level_file, next_spawn_id)
	else:
		push_warning("Nenhuma cena destino foi configurada em:", name)
