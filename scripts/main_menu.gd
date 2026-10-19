extends Control

@export_file("mainmenu.tscn") var main_game_scene: String = "res://scenes/main.tscn"
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var button_hover: AudioStreamPlayer = $ButtonHover

func _ready() -> void:
	if continue_button:
		continue_button.visible = GameManager.jogo_salvo
	var buttons: Array[Node] = find_children("*", "Button",true, false)
	for button in buttons:
		button.mouse_entered.connect(_on_mouse_entered)
	
func _on_mouse_entered():
	button_hover.play()

func _on_continue_button_pressed():
	if GameManager.carregar_jogo():
		get_tree().change_scene_to_file(main_game_scene)

# Novo jogo
func _on_play_button_pressed():
	GameManager.player_position = Vector2.ZERO
	ProgressManager.reset_progress()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_options_button_pressed():
	print("Opções clicado!")

func _on_quit_button_pressed():
	get_tree().quit()
