extends CanvasLayer

@export_file("pausemenu.tscn") var main_menu_scene: String = "res://scenes/mainmenu.tscn"

func _ready() -> void:
	# Começa escondido ao carregar a fase
	hide()

func _unhandled_input(event: InputEvent) -> void:
	# Tecla ESC abre/fecha o menu
	if event.is_action_pressed("ui_cancel"):
		if visible:
			resume_game()
		else:
			pause_game()

func pause_game() -> void:
	show()
	get_tree().paused = true

func resume_game() -> void:
	hide()
	get_tree().paused = false

func _on_resume_button_pressed() -> void:
	resume_game()
	
func _on_save_button_pressed() -> void:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	
	if player:
		GameManager.salvar_jogo(player.global_position, SceneManager.current_level_path)
		print("Progresso salvo com sucesso pelo jogador!")

func _on_main_menu_button_pressed() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		GameManager.salvar_jogo(player.global_position, SceneManager.current_level_path)
	# Despausa o jogo antes de mudar de cena
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu_scene)
