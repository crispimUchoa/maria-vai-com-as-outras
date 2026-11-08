extends Node2D


func _on_interaction_area_interacted() -> void:
	if (not ProgressManager.has_action(ProgressManager.Action.MERENDAR_COM_A_VO_NO_COMECO)):
		DialogManager.start_talk([
			DialogInfoModel.new('player', 'Que fome...'),
			DialogInfoModel.new('player', 'Cuidar ver o que é a merenda.')
			])
		return
	if (not InventoryManager.has_item("Mochila")):
		DialogManager.start_talk([
			DialogInfoModel.new('player', 'Ave Maria, tô esquecendo a mochila!')
		])
