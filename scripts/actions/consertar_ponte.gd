extends Node2D


func _on_interaction_area_interacted() -> void:
	const cutscene = "res://scenes/cutscenes/conserto_ponte.tscn"
	SceneManager.show_cutscene(cutscene, "0", 2.0)
	await SceneManager.cutscene_finished
	DialogManager.start_talk([
		DialogInfoModel.new('player', 'Que desgraça! Esse diabo ta muito quebrado. Vou demorar o dia todin pra ajeitar isso.'),
	])
	await DialogManager.dialog_finished
	
	SceneManager.show_cutscene(cutscene, "1", 2.0)
	ProgressManager.set_act(ProgressManager.Act.PROTEJA_SUA_FAMILIA)
	
	await SceneManager.cutscene_finished
	
	DialogManager.start_talk([
		DialogInfoModel.new('player', 'Ufa! Finalmente acabei! Agora é hora de ir-'),
		
	])
	await DialogManager.dialog_finished
	SceneManager.show_cutscene(cutscene, "2", 2.0)
	await SceneManager.cutscene_finished
	
	DialogManager.start_talk([
		DialogInfoModel.new('player', 'Valha... Tem uma folha amarrada dentro da tábua...'),
		DialogInfoModel.new('player', 'Isso devia tá preso num dos pé de pau que eu derrubei.'),
		DialogInfoModel.new('player', '\"Página 2: O bicho parece que é o tal do lobisome. Tenho que ser zeloso porque o caba é vingativo. Ele sempre mata a família de quem escapa[...] '),
		DialogInfoModel.new('player', '[...] Se você fugiu, \"'),
		DialogInfoModel.new('player', 'A página acaba aqui... Meu Deus, isso é do Diário do Vovô?? Se for, então a página 3 é'),
		DialogInfoModel.new('player', '\"proteja todos e se esconda o mais ligeiro possive. Não deixe sair nem na boquinha noite.\"'),
		DialogInfoModel.new('player', 'MINHA FAMÍLIA! Eu tenho que ir pra casa rápido!'),
		
	])
	await DialogManager.dialog_finished
	
	SceneManager.stop_cutscene()
	ProgressManager.set_mission("Proteja sua família")
