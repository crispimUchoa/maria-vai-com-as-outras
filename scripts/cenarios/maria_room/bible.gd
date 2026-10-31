extends Node2D

var interactions: Array[DialogGroup] = [
	DialogGroup.new([
		DialogInfoModel.new("player", "Vovô conhecia a biblia de cor e salteado."),
		DialogInfoModel.new("player", "Rabiscou tanto a biblia que parecia que tava estudando pra uma prova."),
	]),
	DialogGroup.new([
		DialogInfoModel.new("player", "Daniel 4:33"),
		DialogInfoModel.new("player", "Na mesma hora se cumpriu a palavra sobre Nabucodonosor; e foi expulso dentre os homens, e comia erva como os bois, e o seu corpo foi molhado do orvalho do céu, até que lhe cresceu pelo, como as penas da águia, e as suas unhas como as das aves."),
		DialogInfoModel.new("player", "Que estranho... Por quê vovô destacou isso?"),
	])
]

var current_interaction = 0

func _on_interaction_area_interacted() -> void:
	if (DialogManager.current_dialog == null):
		DialogManager.start_talk(interactions[current_interaction].dialogs)
		current_interaction = (current_interaction + 1) % interactions.size()
	
