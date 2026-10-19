extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var door_creak: AudioStreamPlayer = $Sounds/DoorCreak

var initial_dialogs: Array[DialogInfoModel] = [
	DialogInfoModel.new("player", "Minha Nossa Senhora, que sono miseravi..."),
	DialogInfoModel.new('player',  "Ainda bem que é sexta, não aguento mais ver a lata das pestes da minha escola...")
]


func _ready() -> void:	
	SceneManager.level_change_requested.connect(_on_level_change_requested)
	if GameManager.player_position != Vector2.ZERO and player and GameManager.continued_game:
		player.global_position = GameManager.player_position
	else:
		DialogManager.start_talk(initial_dialogs)
	if (not (ProgressManager.current_level.is_empty() or 
	ProgressManager.current_spawn_id.is_empty())):
		SceneManager.change_level(ProgressManager.current_level, ProgressManager.current_spawn_id)
	
@export var level_container: Node

func _on_level_change_requested(next_level_path: String, next_spawn_id: String):
	if level_container.get_child_count() > 0:
		var current_level = level_container.get_child(0)
		level_container.remove_child(current_level)
		current_level.queue_free()
		
	var next_level_scene = load(next_level_path)
	if (next_level_scene):
		door_creak.play(1.45)

		var new_level = next_level_scene.instantiate()
		level_container.add_child(new_level)
		_position_player(new_level, next_spawn_id)

func _position_player(level: Node, spawn_id: String):
	if !player or spawn_id.is_empty():
		return
	var spawn_point = level.find_child(spawn_id, true, false)
	
	if spawn_point and spawn_point is Node2D:
		player.global_position = spawn_point.global_position
	else:
		push_warning("Ponto de spawn '", spawn_id, "' não foi encontrado na fase: ", level.name)
