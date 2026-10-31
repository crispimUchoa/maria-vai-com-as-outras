extends Node2D


func _on_interaction_area_interacted() -> void:
	DialogManager.start_talk([
		DialogInfoModel.new("player", "Isso aqui é uma mistura de armário e pratrelera..."),
		DialogInfoModel.new("player", "Prateleria"),
		DialogInfoModel.new("player", "Pratilera"),
		DialogInfoModel.new("player", "Pra-tri-lera lera"),
		DialogInfoModel.new("player", "lera lera"),
		DialogInfoModel.new("player", "Misera de madeira!"),
	])
