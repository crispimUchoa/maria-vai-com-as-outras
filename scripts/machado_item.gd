extends Area2D

@export var item_id: String = "machado"

func interact() -> void:
	coletar_machado()

func coletar_machado() -> void:
	InventoryManager.add_item(item_id)
	print("SUCCESSO: Machado coletado e adicionado ao inventário!")
	queue_free() # Remove o machado do mapa
