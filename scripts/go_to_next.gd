extends Node2D

@onready var interaction_area = $InteractionArea
@onready var limit_area = $LimitArea

@export_file(".tscn") var next_level_file: String
@export var next_spawn_id: String = ""
@export var can_go: bool = true
@export_file("*.wav", "*.mp3", "*.ogg") var sound: String
@export var enable_colision = true

func _ready() -> void:
	if (not enable_colision):
		limit_area.process_mode = Node.PROCESS_MODE_DISABLED

var alternative_func: Callable

func _on_interaction_area_interacted() -> void:
	interaction_area.sound = sound
	if not can_go: 
		if alternative_func and alternative_func.is_valid():
			alternative_func.call()
		return
	
	trocar_de_fase()
	
func trocar_de_fase() -> void:
	if next_level_file:
		SceneManager.change_level(next_level_file, next_spawn_id)
	else:
		push_warning("Nenhuma cena destino foi configurada em:", name)
