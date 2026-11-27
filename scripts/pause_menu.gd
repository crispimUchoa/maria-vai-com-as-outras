# PAUSE MENU
extends CanvasLayer

@export_file("*.tscn") var main_menu_scene: String = "res://scenes/mainmenu.tscn"
@onready var buttons_container: VBoxContainer = $ColorRect/VBoxContainer
@onready var button_hover: AudioStreamPlayer = $ButtonHover
@onready var inventory_ui: CanvasLayer = $ColorRect/InventoryUi
@onready var controles_ui: CanvasLayer = $ColorRect/ControlesUi

var _silenciar_foco: bool = false

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	
	var buttons: Array[Node] = find_children("*", "Button", true, false)
	for button in buttons:
		if button is Button:
			button.mouse_entered.connect(_on_mouse_entered.bind(button))
			button.focus_entered.connect(_on_focus_entered)
			
	hide()
	fechar_inventario()
	fechar_controles()

func _on_mouse_entered(button: Button) -> void:
	if not button.has_focus():
		button.grab_focus()

func _on_focus_entered() -> void:
	if not _silenciar_foco:
		button_hover.play()

func _focar_primeiro_botao() -> void:
	if not visible or not buttons_container or not buttons_container.visible:
		return
		
	var botoes_visiveis: Array[Button] = []
	for child in buttons_container.get_children():
		if child is Button and child.visible and not child.disabled:
			botoes_visiveis.append(child)
			
	if botoes_visiveis.is_empty():
		return
		
	# Faz a navegação dar a volta (do último volta ao primeiro e vice-versa)
	var primeiro = botoes_visiveis.front()
	var ultimo = botoes_visiveis.back()
	primeiro.focus_neighbor_top = primeiro.get_path_to(ultimo)
	ultimo.focus_neighbor_bottom = ultimo.get_path_to(primeiro)
	
	_silenciar_foco = true
	primeiro.grab_focus()
	_silenciar_foco = false

func fechar_menus():
	if inventory_ui and inventory_ui.visible:
		fechar_inventario()
	elif controles_ui and controles_ui.visible:
		fechar_controles()
	else:
		resume_game()
		
func _unhandled_input(event: InputEvent) -> void:
	# Tecla ESC / Botão B ou Círculo
	if  event.is_action_pressed("voltar"):
		if visible:
			fechar_menus()
			
	if event.is_action_pressed("ui_cancel"):
		if visible:
			fechar_menus()
		else:
			pause_game()
		get_viewport().set_input_as_handled()
		return

	# Se o menu estiver aberto mas sem foco (ex: clicou fora com o mouse), recupera o foco
	if visible and buttons_container.visible and get_viewport().gui_get_focus_owner() == null:
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
			_focar_primeiro_botao()
			get_viewport().set_input_as_handled()

func pause_game() -> void:
	show()
	fechar_controles()
	fechar_inventario() # Já exibe os botões e chama o foco
	get_tree().paused = true

func resume_game() -> void:
	var foco := get_viewport().gui_get_focus_owner()
	if foco:
		foco.release_focus()
	fechar_inventario()
	fechar_controles()
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
		buttons_container.hide()
		inventory_ui.show()
		if inventory_ui.has_method("atualizar_inventario"):
			inventory_ui.atualizar_inventario()

func fechar_inventario() -> void:
	if inventory_ui:
		inventory_ui.hide()
	if buttons_container:
		buttons_container.show()
	_focar_primeiro_botao()

func fechar_controles() -> void:
	if controles_ui:
		controles_ui.hide()
	if buttons_container:
		buttons_container.show()
	_focar_primeiro_botao()

func _on_controlls_pressed() -> void:
	if controles_ui and buttons_container:
		buttons_container.hide()
		controles_ui.show()
