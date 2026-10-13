extends Node2D

@onready var player: CharacterBody2D = $Player

var initial_dialogs: Array[DialogInfoModel] = [
	DialogInfoModel.new("player", "Minha Nossa Senhora, que sono miseravi..."),
	DialogInfoModel.new('player',  "Ainda bem que é sexta, não aguento mais ver a lata das pestes da minha escola...")
]


func _ready() -> void:	
	print("Sistema inicializado com sucesso!")
	DialogManager.start_talk(initial_dialogs)
	
@export var level_container: Node

func change_level(next_level_path: String):
	if level_container.get_child_count() > 0:
		var current_level = level_container.get_child(0)
		level_container.remove_child(current_level)
		current_level.queue_free()
		
	var next_level_scene = load(next_level_path)
	if (next_level_scene):
		var new_level = next_level_scene.instantiate()
		level_container.add_child(new_level)
