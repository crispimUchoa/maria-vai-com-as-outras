class_name DialogGroup
extends RefCounted

@export var dialogs: Array[DialogInfoModel] = []

func _init(_dialogs: Array[DialogInfoModel]) -> void:
	dialogs = _dialogs
