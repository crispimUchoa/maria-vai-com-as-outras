class_name DialogInfoModel extends Resource

@export var id: String = ""
@export var text: String = ""

func _init(_id: String, _text: String) -> void:
	id=_id
	text=_text
