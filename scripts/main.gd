extends Node2D

@onready var player: CharacterBody2D = $Player

func _ready() -> void:	
	print("Sistema inicializado com sucesso!")

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept")):
		DialogManager.start_talk(player, "Olá, mundo")
