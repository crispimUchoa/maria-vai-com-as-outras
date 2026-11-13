extends Node2D


func _on_interaction_area_interacted() -> void:
	SceneManager.show_cutscene('res://scenes/cutscenes/intimida_padre.tscn', '0')
	DialogManager.start_talk([
		DialogInfoModel.new("player", "E você vai fazer o que pra me impedir?"),
		DialogInfoModel.new("player", "Vai tirar o machado da minha mão? Vai matar minha família inteira?"),
		DialogInfoModel.new("player", "Parece que alguém já fez isso primeiro!"),
		DialogInfoModel.new("padre", "Eu não vou fazer nada. Só peço que você leia as anotações que seu avô removeu do diário e confiou a mim..."),
		DialogInfoModel.new("player", "Confiou a você?"),
		DialogInfoModel.new("padre", "São as páginas que ele escreveu tudo que descobriu sobre mim na época..."),
	])
	await DialogManager.dialog_finished
	SceneManager.show_cutscene('res://scenes/cutscenes/intimida_padre.tscn', '1')
	DialogManager.start_talk([
			DialogInfoModel.new("player", "\"Descobri que ele é um bom rapaz. Simpático e zeloso.\""),
			DialogInfoModel.new("player", "\"Pelo visto, ele ainda não sabe que pode se transformar.\""),
			DialogInfoModel.new("player", "\"Foi acolhido por um padre que fez de tudo para curá-lo dessa maldição.\""),
			DialogInfoModel.new("player", "\"Esse é o fardo de ser o sétimo filho homem nascido numa noite de Lua Cheia.\""),
			DialogInfoModel.new("player", "\"Não tive coragem de matar esse sujeito de coração puro. Estamos conseguindo controlar as transformações.\""),
			DialogInfoModel.new("player", "\"Descobri que o Padre é safado. O caba vai ser pai. Que loucura.\""),
			DialogInfoModel.new("player", "\"Não lembro da última vez que ele se transformou. Me pergunto o que fez isso acontecer...\""),
			
		])
	await DialogManager.dialog_finished
	ProgressManager.set_act(ProgressManager.Act.VINGAR_FAMILIA)
	ProgressManager.set_mission("Faça o que tem que ser feito")
	SceneManager.stop_cutscene()
