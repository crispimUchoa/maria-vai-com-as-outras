extends StaticBody2D


func _on_interaction_area_interacted() -> void:
	DialogManager.start_talk([
		DialogInfoModel.new("maria", "Bença pai!"),
		DialogInfoModel.new("pai_maria", "Deus te abençoe minha filha."),
		DialogInfoModel.new("pai_maria", "Se cuide."),
	])
	get_parent().pedir_benca()
