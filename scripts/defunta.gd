extends Node2D

const cutscene: String = "res://scenes/cutscenes/dead_girl.tscn"
const interval: float = 1.0
func _on_interaction_area_interacted() -> void:
	if (ProgressManager.is_act(ProgressManager.Act.DEAD_GIRL_WARNING)): 
		SceneManager.show_cutscene(cutscene, "2", interval)
		await SceneManager.cutscene_finished
		
		DialogManager.start_talk([
		DialogInfoModel.new('player', "Meu Deus..."),
		DialogInfoModel.new('player', "O que matou ela fugiu pra lá... Preciso avisar a todos.")
		])
		await DialogManager.dialog_finished
		SceneManager.stop_cutscene()
		
		
		return
	# 1. Cutscene Quadro 1
	DialogManager.start_talk([
		DialogInfoModel.new('player', "O que isso? Ela ta dormino?"),
		DialogInfoModel.new('player', "Oxi, é a fia da dona Zumira! O que el-")
	])
	await DialogManager.dialog_finished
	
	
	SceneManager.show_cutscene(cutscene, "0", interval)
	await SceneManager.cutscene_finished
	DialogManager.start_talk([
		DialogInfoModel.new('player', "SANGUE! MEU DEUS! ISSO É"),
	])
	await DialogManager.dialog_finished
	
	
	# 3. Cutscene Quadro 2 (Apenas altera a imagem sem fechar o nó)
	SceneManager.show_cutscene(cutscene, "1", interval)
	await SceneManager.cutscene_finished
	
	# 4. Segundo Diálogo
	DialogManager.start_talk([
		DialogInfoModel.new('player', "AAAAAAAAAAAAAAAAAAAAAAAAAAAA!")
	])
	await DialogManager.dialog_finished
	
	# 5. Cutscene Quadro 3
	SceneManager.show_cutscene(cutscene, "2", interval)
	await SceneManager.cutscene_finished
	
	# 6. Terceiro Diálogo
	DialogManager.start_talk([
		DialogInfoModel.new('player', "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!")
	])
	await DialogManager.dialog_finished
	
	# 7. Finaliza a cutscene e despausa o jogo de verdade!
	ProgressManager.set_act(ProgressManager.Act.DEAD_GIRL_WARNING)
	
	SceneManager.stop_cutscene()
