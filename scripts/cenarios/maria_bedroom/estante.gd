extends Node2D


var dialogs: Array[DialogInfoModel] = [
	DialogInfoModel.new('player', "A estante ta bem empoeirada..."),
	DialogInfoModel.new('player', "Faz tempo que não leio um bom livro."),
	DialogInfoModel.new('player', "Esse fim de semana eu começo um novo."),
]


func _on_interaction_area_interacted() -> void:
	DialogManager.start_talk(dialogs)
