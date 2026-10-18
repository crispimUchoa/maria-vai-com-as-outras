extends Node

const SAVE_PATH = "user://savegame.cfg"

# Controla se existe um jogo em andamento
var jogo_salvo: bool = false
var player_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	verificar_save_existente()
	
func verificar_save_existente() -> void:
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	if err == OK:
		jogo_salvo = true
	else:
		jogo_salvo = false

func salvar_jogo(posicao_jogador: Vector2) -> void:
	var config = ConfigFile.new()
	
	config.set_value("Player", "pos_x", posicao_jogador.x)
	config.set_value("Player", "pos.y", posicao_jogador.y)
	
	var err = config.save(SAVE_PATH)
	if err == OK:
		jogo_salvo = true
		print("Jogo salvo com sucesso!")
		
func carregar_jogo() -> bool:
		var config = ConfigFile.new()
		var err = config.load(SAVE_PATH)
		
		if err == OK:
			var x = config.get_value("Player", "pos_x", 0.0)
			var y = config.get_value("Player", "pos_y", 0.0)
			player_position = Vector2(x, y)
			return true
		
		return false
