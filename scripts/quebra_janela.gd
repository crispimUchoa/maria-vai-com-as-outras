extends Node2D

func _on_interaction_area_interacted() -> void:
	SceneManager.show_cutscene("res://scenes/cutscenes/maria_quebra_janela.tscn", "maria_quebra_janela")
	await SceneManager.cutscene_finished
	SceneManager.show_cutscene("res://scenes/cutscenes/maria_quebra_janela.tscn", "janela_quebrada")
	await SceneManager.cutscene_finished
	SceneManager.stop_cutscene()
	DialogManager.start_talk([
		DialogInfoModel.new('player', 'MEU DEUS! Não é o Jenebelso!')
	])
