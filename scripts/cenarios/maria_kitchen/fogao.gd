extends Node2D


func _on_interaction_area_interacted() -> void:
	DialogManager.start_talk([
		DialogInfoModel.new("player", "Fogão a lenha..."),
		DialogInfoModel.new("player", "Lenha é a madeira que pega fogo e fogão é o que?"),
		DialogInfoModel.new("player", "Se tirar a lenha sobra só o fogão."),
		DialogInfoModel.new("player", "Então, fogão é uma ruma de tijolo?"),
	])
