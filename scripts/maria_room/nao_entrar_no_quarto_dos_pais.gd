extends Node2D


func _on_interaction_area_interacted() -> void:
	DialogManager.start_talk([
			DialogInfoModel.new('player', 'Tô atrasada, melhor não perder tempo aqui...')
		])
