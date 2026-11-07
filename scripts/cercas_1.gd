extends TileMap # Caso use Godot 4.3+ com o nó TileMapLayer, mude para: extends TileMapLayer

@export var required_item: String = "machado"
@export var puff_effect_scene: PackedScene = preload("res://scenes/puff_effect.tscn")

# Chamado pela AxeHitbox ao golpear o TileMap
func quebrar_tile_na_posicao(global_hit_position: Vector2) -> void:
	# Convertemos a posição global do machado para a coordenada de célula (tile) do grid
	var tile_pos: Vector2i = local_to_map(to_local(global_hit_position))
	
	# Identifica o ID do tile na posição atingida (Layer 0 por padrão)
	# Se for Godot 4.0-4.2 (TileMap clássico):
	var cell_source_id = get_cell_source_id(0, tile_pos)
	# Se for Godot 4.3+ (TileMapLayer):
	# var cell_source_id = get_cell_source_id(tile_pos)
	
	# Se a célula não estiver vazia (-1 é o valor de célula sem tile)
	if cell_source_id != -1:
		# 1. Checa o inventário do Player
		if not InventoryManager.has_item(required_item):
			if not DialogManager.is_open():
				DialogManager.start_talk([
					DialogInfoModel.new('player', 'Ah inferno pra tê cão! Não dá pra eu passar!!!'),
					DialogInfoModel.new('player', 'Vou ter que encontrar um machado')
				])
			return
		
		# 2. Gera o efeito "Puff" no centro do tile atingido
		gerar_puffeffect(map_to_local(tile_pos))
		
		# 3. Remove a cerca do mapa (define a célula como vazia)
		# Se for TileMap clássico:
		set_cell(0, tile_pos, -1)
		# Se for TileMapLayer (Godot 4.3+):
		# set_cell(tile_pos, -1)

func gerar_puffeffect(posicao_local: Vector2) -> void:
	if puff_effect_scene:
		var puff = puff_effect_scene.instantiate()
		puff.global_position = to_global(posicao_local)
		get_parent().add_child(puff)
