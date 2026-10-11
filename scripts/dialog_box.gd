extends PanelContainer

@onready var texture_container: TextureRect = $TextureRect
@onready var portrait_rect: TextureRect = $Container/HBoxContainer/TextureRect
@onready var text_label: RichTextLabel = $Container/HBoxContainer/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_label.text = ""

func setup(text: String, portrait: Texture2D):
	portrait_rect.texture = portrait
	text_label.text = text

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept")):
		queue_free();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
