extends Control

@export_file("mainmenu.tscn") var main_game_scene: String = "res://scenes/main.tscn"
@onready var continue_button: Button = $VBoxContainer/ContinueButton

func _ready() -> void:
	if continue_button:
		continue_button.visible = GameManager.jogo_salvo

func _on_continue_button_pressed():
	get_tree().change_scene_to_file(main_game_scene)

func _on_play_button_pressed():
	GameManager.jogo_salvo = true
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_options_button_pressed():
	print("Opções clicado!")

func _on_quit_button_pressed():
	get_tree().quit()
