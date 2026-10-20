extends Node2D

func _on_interaction_area_interacted() -> void:
	if (DialogManager.current_dialog == null):
		DialogManager.start_talk([
		DialogInfoModel.new("player", "Faz um ano que o Nelso fez xixi aqui e ainda fede."),
		DialogInfoModel.new("player", "Mas eu deitaria pra tirar um cochilo agora mesmo assim..."),
		DialogInfoModel.new("player", "Se eu pudesse, é claro."),
	])
	
