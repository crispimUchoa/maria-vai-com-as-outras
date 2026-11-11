extends Node2D



func _on_interaction_area_interacted() -> void:
	const interval = 5.0
	const cutscene = 'res://scenes/cutscenes/alerta.tscn'
	SceneManager.show_cutscene(cutscene,"0", interval)
	await SceneManager.cutscene_finished
	SceneManager.show_cutscene(cutscene,"1", interval)
	await SceneManager.cutscene_finished
	SceneManager.show_cutscene(cutscene,"2", interval)
	await SceneManager.cutscene_finished
	SceneManager.stop_cutscene()
	ProgressManager.set_act(ProgressManager.Act.ESPOCA_BUCHO)
