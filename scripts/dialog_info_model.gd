class_name DialogModel extends Resource

@export var display_name: String = ""
@export var portrait: Texture2D

func _init(name: String, texture: Texture2D) -> void:
	display_name=name
	portrait=texture
