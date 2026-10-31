extends Node2D


func _on_interaction_area_interacted() -> void:
	match ProgressManager.current_act:
		ProgressManager.Act.BEGIN_MARIA_HOUSE:
			DialogManager.start_talk([
				DialogInfoModel.new("player", "Bom dia, vovó! Bença!"),
				DialogInfoModel.new("vovo", 
				"Bom dia! Deus te abençoe, minha netinha linda!"),
				DialogInfoModel.new("vovo", "Cafézin e cuscuz já tão feitos!"),
				DialogInfoModel.new("player", "Pois vou logo arrochar que a fome ta medonha!"),
			])
			await DialogManager.dialog_finished
			ProgressManager.current_act = ProgressManager.Act.BEGIN_GO_TO_SCHOOL
			SceneManager.show_cutscene('res://scenes/cutscenes/act_0_cuscuz.tscn', '0', 2.5)
			await SceneManager.cutscene_finished
			SceneManager.stop_cutscene()
			
		_:
			DialogManager.start_talk([
				DialogInfoModel.new("vovo", "É bom se apressar!"),
				DialogInfoModel.new("vovo", "Já faltou aula demais..."),
			])
