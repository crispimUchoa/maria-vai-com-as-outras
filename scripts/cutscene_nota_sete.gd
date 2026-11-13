extends Node2D



func _on_interaction_area_interacted() -> void:
	SceneManager.show_cutscene("res://scenes/cutscenes/investigar_nota_igreja.tscn", "0")
	DialogManager.start_talk([
		DialogInfoModel.new("player", "Droga..."),
		DialogInfoModel.new("player", "O que diabo isso significa?"),
	])
	await DialogManager.dialog_finished
	
	SceneManager.stop_cutscene()
	
