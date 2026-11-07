extends Area2D

@export var damage_amount: int = 1

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# se for tilemap
	# Alinha com a função quebrar_tile_na_posicao passando o argumento de posição
	if body.has_method("quebrar_tile"):
		body.quebrar_tile(global_position)
	elif body.has_method("take_damage"):
		body.take_damage(damage_amount)

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent and parent.has_method("take_damage"):
		parent.take_damage(damage_amount)
