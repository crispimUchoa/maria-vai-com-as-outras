extends Area2D

@export var damage_amount: int = 1
@onready var collision_shape: CollisionShape2D = $CollisionAxe

func _ready() -> void:
	monitoring = true
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	print("--- AxeHitbox pronta e monitorando ---")

func _on_body_entered(body: Node2D) -> void:
	_processar_impacto(body)

func _on_area_entered(area: Area2D) -> void:
	_processar_impacto(area)

func _processar_impacto(target: Node) -> void:
	print("!!! COLIDIU COM: ", target.name, " !!!")
	
	# 1. Se for uma cerca ou objeto que usa o script destroi_objeto.gd / Area2D
	if target.has_method("quebrar"):
		target.quebrar()
	elif target.has_method("take_damage"):
		target.take_damage(damage_amount)
		
	# 2. Suporte legado caso toque em um TileMapLayer
	elif target.has_method("quebrar_tile"):
		var posicao_impacto: Vector2 = collision_shape.global_transform.origin
		target.quebrar_tile(posicao_impacto)
