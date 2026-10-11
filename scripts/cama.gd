extends Node2D


var dialogs: Array[DialogInfoModel] = [
	DialogInfoModel.new('player', "Que vontade de tirar um cochilo, escola véia do diabo!"),
	DialogInfoModel.new('player', "Esse frio das cinco da manhã não foi feito para se estar acordada...")
]


func _on_interaction_area_interacted() -> void:
	DialogManager.start_talk(dialogs)
