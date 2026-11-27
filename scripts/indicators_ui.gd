extends Node2D

@onready var machado_ui: CanvasLayer = $Machado
@onready var key_press_ui: CanvasLayer = $KeyPress

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.change_key_press_ui_request.connect(_on_change_key_press_ui)
	GameManager.change_machado_ui_request.connect(_on_change_machado_ui)
	if (InventoryManager.has_item("Machado")):
		GameManager.set_machado_ui_visibility(true)

func _on_change_key_press_ui(visible: bool):
	key_press_ui.visible = visible
	
func _on_change_machado_ui(visible: bool):
	machado_ui.visible = visible
