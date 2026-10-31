extends Area2D

@export var item_id: String = "Mochila"
var player_in_range: bool = false

@onready var label_interacao: Label = $Label_mochila

func _ready() -> void:
	if label_interacao:
		label_interacao.visible = false
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true
		if label_interacao:
			label_interacao.visible = true
			
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		if label_interacao:
			label_interacao.visible = false

func interact() -> void:
	coletar_mochila()

func coletar_mochila() -> void:
	InventoryManager.add_item(item_id)
	print("SUCCESSO: Mochila coletado e adicionado ao inventário!")
	queue_free() # Remove item do mapa
