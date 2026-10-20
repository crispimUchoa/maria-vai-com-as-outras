class_name DialogBox extends PanelContainer

@onready var portrait_rect: TextureRect = $Container/MarginContainer/HBoxContainer/TextureRect
@onready var text_label: RichTextLabel = $Container/MarginContainer/HBoxContainer/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_label.text = ""

var dialog_lines: Array = []
var dialog_index = 0

func setup(lines: Array):
	dialog_lines = lines
	dialog_index = 0
	
	show_current_line()

func show_current_line():
	var current = dialog_lines[dialog_index]
	portrait_rect.texture = current.portrait
	text_label.text = current.text

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept")):
		dialog_index += 1
		
		if dialog_index < dialog_lines.size():
			show_current_line()
		else:
			queue_free();
