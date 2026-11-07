extends TileMapLayer

@export var required_item: String = "machado"
@export var puff_effect_scene: PackedScene = preload("res://scenes/puff_effect.tscn")

# Chamado pela AxeHitbox ao golpear o TileMapLayer
func quebrar_tile(global_hit_position: Vector2) -> void:
	# 1. Converte a posição global do golpe para a coordenada local do grid (Vector2i)
	var tile_pos: Vector2i = local_to_map(to_local(global_hit_position))
	
	# Identifica se existe um tile válido nessa célula
	var cell_id: int = get_cell_source_id(tile_pos)
	
	# Se cell_source_id for diferente de -1, existe um tile preenchido nessa posição
	if cell_id != -1:
		# Validação do inventário do jogador
		if not InventoryManager.has_item(required_item):
			if not DialogManager.is_open():
				DialogManager.start_talk([
					DialogInfoModel.new('player', 'Ah inferno pra tê cão! Não dá pra eu passar!!!'),
					DialogInfoModel.new('player', 'Vou ter que encontrar um machado')
				])
			return
		
		# Gera o efeito visual "Puff" centralizado no tile que foi atingido
		gerar_puffeffect(map_to_local(tile_pos))
		
		# Remove a cerca do mapa definindo a célula como vazia (-1)
		set_cell(tile_pos, -1)

func gerar_puffeffect(posicao_local: Vector2) -> void:
	if puff_effect_scene:
		var puff = puff_effect_scene.instantiate()
		puff.global_position = to_global(posicao_local)
		get_parent().add_child(puff)
