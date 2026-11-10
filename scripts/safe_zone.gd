extends Area2D

# Arraste o nó do Lobisomem no Inspector do Godot (caso ele esteja na mesma cena)
@export var lobisomem_node: Lobisomem 

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Opção 1: A Maria entrou na Safe Zone e o Lobisomem especificado ainda existe no mapa
	if body.name == "Maria" and is_instance_valid(lobisomem_node):
		lobisomem_node.despistar()
		return

	# Opção 2: O próprio Lobisomem encostou na Safe Zone enquanto perseguia a Maria
	if body is Lobisomem:
		body.despistar()
