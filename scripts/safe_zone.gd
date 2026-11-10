extends Area2D

# Arraste o nó do Lobisomem no Inspector do Godot (caso ele esteja na mesma cena)
@export var lobisomem_node: Lobisomem 

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player: 
		if is_instance_valid(lobisomem_node):
			lobisomem_node.despistar() 
