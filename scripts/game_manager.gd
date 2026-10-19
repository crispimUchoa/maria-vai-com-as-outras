extends Node

const SAVE_PATH = "user://savegame.cfg"

# Controla se existe um jogo em andamento
var jogo_salvo: bool = false
var player_position: Vector2 = Vector2.ZERO
var continued_game = false
var current_level: String = ""

func _ready() -> void:
	verificar_save_existente()
	
func verificar_save_existente() -> void:
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	if err == OK:
		jogo_salvo = true
	else:
		jogo_salvo = false

func salvar_jogo(posicao_jogador: Vector2, current_level: String) -> void:
	var config = ConfigFile.new()
	
	config.set_value("Player", "pos_x", posicao_jogador.x)
	config.set_value("Player", "pos_y", posicao_jogador.y)
	config.set_value("Player", "current_level", current_level)
	
	var err = config.save(SAVE_PATH)
	if err == OK:
		jogo_salvo = true
		
func carregar_jogo() -> bool:
		var config = ConfigFile.new()
		var err = config.load(SAVE_PATH)
		
		if err == OK:
			var x = config.get_value("Player", "pos_x", 0.0)
			var y = config.get_value("Player", "pos_y", 0.0)
			var current_level = config.get_value("Player", "current_level", "")
			player_position = Vector2(x, y)
			ProgressManager.current_scene = current_level
			continued_game = true
			return true
		
		return false
