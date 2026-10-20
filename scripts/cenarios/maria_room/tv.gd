extends Node2D

var interactions: Array[DialogGroup] = [
	DialogGroup.new([
		DialogInfoModel.new("player", "Saudades de quando essa bicha dava vídeo direitin."),
		DialogInfoModel.new("player", "Pelo menos a zuada ainda presta."),
		DialogInfoModel.new("player", "Rádio bom da mizera!"),
	]),
	DialogGroup.new([
		DialogInfoModel.new("player", "Na hora da novela, é só dar 4 tapa que tem 2 tempo de tela."),
		DialogInfoModel.new("player", "Mas aí ela fica num chiado danado..."),
		DialogInfoModel.new("player", "Existem sacrifícios que valem a pena."),
	])
]

var current_interaction = 0

func _on_interaction_area_interacted() -> void:
	if (DialogManager.current_dialog == null):
		DialogManager.start_talk(interactions[current_interaction].dialogs)
		current_interaction = (current_interaction + 1) % interactions.size()
	
