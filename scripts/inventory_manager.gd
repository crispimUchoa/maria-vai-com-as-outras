extends Node

# Sinal emitido sempre que o inventário  for alterado (atualiza a UI)
signal inventory_updated

# Lista de IDs ou nomes dos itens coletados
var items : Array = []

func add_item(item_id: String) -> void:
	if not items.has(item_id):
		items.append(item_id)
		inventory_updated.emit()
		print("Item coletado:", item_id)
		
func remove_item(item_id: String) -> void:
	if items.has(item_id):
		items.erase(item_id)
		inventory_updated.emit()
		print("Item usado:", item_id)
		
func has_item(item_id: String) -> bool:
	return items.has(item_id)
