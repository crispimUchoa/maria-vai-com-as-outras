extends CharacterBody2D
class_name Lobisomem

@export var max_health: int = 3
var current_health: int

func _ready() -> void:
	current_health = max_health

# mesma função que o machado chama
func take_damage(amount: int = 1) -> void:
	current_health -= amount
	print("Lobisomem recebeu ", amount, " de dano. HP restante: ", current_health)
	
	if current_health <= 0:
		die()

func die() -> void:
	queue_free()
