extends CanvasLayer

@onready var container = $GridContainer

func _ready() -> void:
	# se conecta ao sinal do InventoryManager
	InventoryManager.inventory_updated.connect(atualizar_inventario)
	atualizar_inventario()
	
func atualizar_inventario() -> void:
	if not container:
		return
		
	# Limpa os elementos antigos
	for child in container.get_children():
		child.queue_free()
		
	# Se o inventário estiver vazio
	if InventoryManager.items.is_empty():
		var empty_label := Label.new()
		empty_label.text = "Inventário Vazio"
		empty_label.custom_minimum_size = Vector2(120, 24)
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		container.add_child(empty_label)
		return

	# Se houver itens
	for item_id in InventoryManager.items:
		var item_label := Label.new()
		item_label.text = "• " + String(item_id).capitalize()
		item_label.custom_minimum_size = Vector2(80, 24)
		item_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		item_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		container.add_child(item_label)
