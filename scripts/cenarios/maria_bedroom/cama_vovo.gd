extends Node2D


var dialogs: Array[DialogInfoModel] = [
	DialogInfoModel.new('player', "Vovó levantou cedo como sempre!"),
]


func _on_interaction_area_interacted() -> void:
	DialogManager.start_talk(dialogs)
