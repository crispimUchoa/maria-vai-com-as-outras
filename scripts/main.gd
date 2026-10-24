extends Node2D

@onready var level_container: Node2D = $LevelContainer
@onready var initial_player_spawn: Marker2D = $InitialSpawn
@onready var door_creak: AudioStreamPlayer = $Sounds/DoorCreak

var spawn_point_id = ""
var current_level_node: Node2D = null
const PLAYER_SCENE = preload("res://scenes/player.tscn")
var player = null
var initial_dialogs: Array[DialogInfoModel] = [
	DialogInfoModel.new("player", "Minha Nossa Senhora, que sono miseravi..."),
	DialogInfoModel.new('player',  "Ainda bem que é sexta, não aguento mais ver a lata das pestes da minha escola...")
]

func spawn_player(initial_spawn: bool=false):
	player = PLAYER_SCENE.instantiate()
	player.scale = Vector2(1.35, 1.35)
	if (initial_spawn):
		player.global_position = initial_player_spawn.global_position
	else:
		_position_player(current_level_node, spawn_point_id)
	if (current_level_node == null):
		current_level_node = level_container.get_child(0)
	current_level_node.add_child(player)

func _ready() -> void:	
	SceneManager.level_change_requested.connect(_on_level_change_requested)
	if GameManager.player_position != Vector2.ZERO and GameManager.continued_game:
		spawn_player()
		player.global_position = GameManager.player_position
	else:
		current_level_node = level_container.get_child(0)
		DialogManager.start_talk(initial_dialogs)
		spawn_player(true)
	if (not (ProgressManager.current_level.is_empty() or 
	ProgressManager.current_spawn_id.is_empty())):
		SceneManager.change_level(ProgressManager.current_level, ProgressManager.current_spawn_id)
	

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
		current_level_node = new_level
		spawn_point_id = next_spawn_id
		spawn_player()
		

func _position_player(level: Node, spawn_id: String):
	if !player or spawn_id.is_empty():
		return
	var spawn_point = level.find_child(spawn_id, true, false)
	
	if spawn_point and spawn_point is Node2D:
		player.global_position = spawn_point.global_position
	else:
		push_warning("Ponto de spawn '", spawn_id, "' não foi encontrado na fase: ", level.name)
