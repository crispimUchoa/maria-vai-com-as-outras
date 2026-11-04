extends CanvasLayer

@export_file("pausemenu.tscn") var main_menu_scene: String = "res://scenes/mainmenu.tscn"
@onready var buttons_container: VBoxContainer = $ColorRect/VBoxContainer
@onready var button_hover: AudioStreamPlayer = $ButtonHover
@onready var inventory_ui: CanvasLayer = $ColorRect/InventoryUi

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	
	var buttons: Array[Node] = find_children("*", "Button", true, false)
	for button in buttons:
		button.mouse_entered.connect(_on_mouse_entered)
	hide()
	fechar_inventario()

func _on_mouse_entered() -> void:
	button_hover.play()

func _unhandled_input(event: InputEvent) -> void:
	# Tecla ESC
	if event.is_action_pressed("ui_cancel"):
		if visible:
			# Se o inventário estiver aberto, fecha ele e volta aos botões primeiro
			if inventory_ui and inventory_ui.visible:
				fechar_inventario()
			else:
				resume_game()
		else:
			pause_game()

func pause_game() -> void:
	show()
	fechar_inventario() # Exibe os botões ao pausar
	get_tree().paused = true

func resume_game() -> void:
	fechar_inventario()
	hide()
	get_tree().paused = false

func _on_resume_button_pressed() -> void:
	resume_game()

func _on_save_button_pressed() -> void:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	if player:
		GameManager.salvar_jogo(player.global_position)

func _on_main_menu_button_pressed() -> void:
	_on_save_button_pressed()
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu_scene)

func _on_inventory_button_pressed() -> void:
	if inventory_ui and buttons_container:
		# Esconde os botões do pause e mostra a tela do inventário
		buttons_container.hide()
		inventory_ui.show()
		
		# Delega a atualização para o próprio script da UI do inventário
		if inventory_ui.has_method("atualizar_inventario"):
			inventory_ui.atualizar_inventario()

func fechar_inventario() -> void:
	if inventory_ui:
		inventory_ui.hide()
	if buttons_container:
		buttons_container.show()
