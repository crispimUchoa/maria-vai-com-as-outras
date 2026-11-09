extends Node

const SAVE_PATH = "user://savegame.cfg"

# ve se tem jogo salvo
var jogo_salvo: bool = false
var player_position: Vector2 = Vector2.ZERO
var continued_game: bool = false

var objeto_destruido: Array = []

func _ready() -> void:
	verificar_save_existente()

func registrar_objeto_destruido(id: String) -> void:
	if not objeto_destruido.has(id):
		objeto_destruido.append(id)

func is_objeto_destruido(id: String) -> bool:
	return objeto_destruido.has(id)

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
	config.set_value("Player", "pos_y", posicao_jogador.y)
	config.set_value("Player", "progress", ProgressManager.save_progress())
	config.set_value("Inventory", "items", InventoryManager.items)
	
	# salva objetos destruídos
	config.set_value("World", "objetos_destruidos", objeto_destruido)
	
	var err = config.save(SAVE_PATH)
	if err == OK:
		jogo_salvo = true
		print("Jogo salvo com sucesso!")

func carregar_jogo() -> bool:
	var config = ConfigFile.new()
	var loaded_items = config.get_value("Inventory", "items", [])
	var err = config.load(SAVE_PATH)
	
	if loaded_items is Array:
		InventoryManager.items.clear()
		InventoryManager.items.assign(loaded_items)
		
	if InventoryManager.has_signal("inventory_updated"):
		InventoryManager.inventory_updated.emit()
	
	if err == OK:
		# Carrega a posição do jogador
		var x = config.get_value("Player", "pos_x", 0.0)
		var y = config.get_value("Player", "pos_y", 0.0)
		player_position = Vector2(x, y)
		
		# Carrega o progresso de fase
		var progress = config.get_value("Player", "progress", ProgressManager.INITIAL_PROGRESS)
		ProgressManager.load_progress(progress)
		
		# Carrega os itens do inventário (USANDO get_value)
		InventoryManager.items = config.get_value("Inventory", "items", [])
		if InventoryManager.has_signal("inventory_updated"):
			InventoryManager.inventory_updated.emit()
			
		# Carrega a lista de objetos destruídos
		objeto_destruido = config.get_value("World", "objetos_destruidos", [])
		
		continued_game = true
		
		# Retorna true apenas DEPOIS de carregar todas as informações
		return true
		
	return false
