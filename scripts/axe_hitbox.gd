extends Area2D

@export var damage_amount: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _on_body_entered(body: Node2D) -> void:
	# se for tilemap
	if body.has_method("quebrar_tile"):
		body.quebrar_tile()
	# se for inimigo ou staticbody / characterbody
	elif body.has_method("take_damage"):
		body.take_damage(damage_amount)

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent and parent.has_method("take_damage"):
		parent.take_damage(damage_amount)
