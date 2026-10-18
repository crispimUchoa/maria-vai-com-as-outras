extends Node2D

func _on_interaction_area_interacted() -> void:
	DialogManager.start_talk([
		DialogInfoModel.new('player', "O que isso? Ela ta dormino?"),
		DialogInfoModel.new('player', "Oxi, é a fia da dona Zumira! O que el-"),
		DialogInfoModel.new('player', "SANGUE! MEU DEUS! ISSO É"),
		DialogInfoModel.new('player', "AAAAAAAAAAAAAAAAAAAAAAAAAAAA!"),
		DialogInfoModel.new('player', "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!"),
	])
