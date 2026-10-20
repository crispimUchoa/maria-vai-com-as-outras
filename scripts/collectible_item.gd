extends Area2D

@export var item_id: String = "livro"

func _ready() -> void:
	# conecta o sinal de quando o player entra na area
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		InventoryManager.add_item(item_id)
		queue_free() # remove item do mapa após coleta
