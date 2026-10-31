extends Node2D


var dialogs: Array[DialogInfoModel] = [
	DialogInfoModel.new('player', "Mabi ta bem grandinha já!"),
	DialogInfoModel.new('player', "Tá quase do tamanho de uma árvore!"),
]


func _on_interaction_area_interacted() -> void:
	DialogManager.start_talk(dialogs)
