extends Node2D

@export var lobisomem_scene: PackedScene = preload("res://scenes/lobisomem.tscn")
@onready var lobisomem_spawn: Marker2D = $LobisomemSpawn

func _ready() -> void:
	# Só cria o Lobisomem na cena se a Maria estiver na fase de fuga
	if ProgressManager.is_act(ProgressManager.Act.DEAD_GIRL_WARNING):
		if lobisomem_scene and lobisomem_spawn:
			await get_tree().create_timer(1,0).timeout
			var lobisomem = lobisomem_scene.instantiate()
			lobisomem.global_position = lobisomem_spawn.global_position
			add_child(lobisomem) 
