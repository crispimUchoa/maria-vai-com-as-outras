## MAIN MENU
extends Control

@export_file("*.tscn") var main_game_scene: String = "res://scenes/main.tscn"
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var button_hover: AudioStreamPlayer = $ButtonHover
@onready var controles_ui: CanvasLayer = $ControlesUi
@onready var vboxContainer: VBoxContainer = $VBoxContainer

var _silenciar_foco: bool = false

func _ready() -> void:
	if continue_button:
		continue_button.visible = GameManager.jogo_salvo
		
	var buttons: Array[Node] = find_children("*", "Button", true, false)
	for button in buttons:
		if button is Button:
			button.mouse_entered.connect(_on_mouse_entered.bind(button))
			button.focus_entered.connect(_on_focus_entered)
			
	fechar_controles()

func _on_mouse_entered(button: Button) -> void:
	if not button.has_focus():
		button.grab_focus()

func _on_focus_entered() -> void:
	if not _silenciar_foco:
		button_hover.play()

func _focar_primeiro_botao() -> void:
	if not vboxContainer or not vboxContainer.visible:
		return
		
	var botoes_visiveis: Array[Button] = []
	for child in vboxContainer.get_children():
		if child is Button and child.visible and not child.disabled:
			botoes_visiveis.append(child)
			
	if botoes_visiveis.is_empty():
		return
		
	var primeiro = botoes_visiveis.front()
	var ultimo = botoes_visiveis.back()
	primeiro.focus_neighbor_top = primeiro.get_path_to(ultimo)
	ultimo.focus_neighbor_bottom = ultimo.get_path_to(primeiro)
	
	_silenciar_foco = true
	primeiro.grab_focus()
	_silenciar_foco = false

func _on_continue_button_pressed() -> void:
	if GameManager.carregar_jogo():
		get_tree().change_scene_to_file(main_game_scene)

# Novo jogo
func _on_play_button_pressed() -> void:
	GameManager.player_position = Vector2.ZERO
	GameManager.objeto_destruido = []
	ProgressManager.reset_progress()
	get_tree().change_scene_to_file(main_game_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_controlls_button_pressed() -> void:
	vboxContainer.hide()
	controles_ui.show()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel")  or event.is_action_pressed("voltar"):
		if controles_ui and controles_ui.visible:
			fechar_controles()
			get_viewport().set_input_as_handled()
			return

	# Recupera o foco se o usuário clicou fora com o mouse
	if vboxContainer.visible and get_viewport().gui_get_focus_owner() == null:
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
			_focar_primeiro_botao()
			get_viewport().set_input_as_handled()

func fechar_controles() -> void:
	if controles_ui:
		controles_ui.hide()
	if vboxContainer:
		vboxContainer.show()
	_focar_primeiro_botao.call_deferred()
