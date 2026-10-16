extends Node2D


func _on_interaction_area_interacted() -> void:
	match ProgressManager.current_act:
		ProgressManager.Act.BEGIN_MARIA_HOUSE:
			DialogManager.start_talk([
				DialogInfoModel.new("player", "Bom dia, vovó!"),
				DialogInfoModel.new("vovo", "Bom dia, minha netinha linda!"),
				DialogInfoModel.new("vovo", "Cafézin e cuscuz já tão feitos!"),
				DialogInfoModel.new("player", "Pois vou logo arrochar que a fome ta medonha!"),
			])
			ProgressManager.current_act = ProgressManager.Act.BEGIN_GO_TO_SCHOOL
		_:
			DialogManager.start_talk([
				DialogInfoModel.new("vovo", "É bom se apressar!"),
				DialogInfoModel.new("vovo", "Já faltou aula demais..."),
			])
