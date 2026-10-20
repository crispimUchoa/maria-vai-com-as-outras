extends CanvasLayer

@onready var container = $GridContainer

func _ready() -> void:
	# se conecta ao sinal do InventoryManager
	InventoryManager.inventory_update.connect(update_ui)
	update_ui()
	
func update_ui() -> void:
	# limpa a interface atual
	for child in container.get_children():
		child.queue_free()
		
	# cria um ícone/texto para cada item no inventário
	for item_id in InventoryManager.items:
		var label = Label.new()
		label.text = "[" + item_id + "]"
		container.add_child(label)
