extends Node2D

var washed_hands: bool = false

func _on_interaction_area_interacted() -> void:
	match ProgressManager.current_act:
		ProgressManager.Act.BEGIN_MARIA_HOUSE:
			if (not washed_hands):
				DialogManager.start_talk([
					DialogInfoModel.new("player", "É bom lavar as mãos antes de comer, né?"),
					DialogInfoModel.new("vovo", "Depende..."),
					DialogInfoModel.new("vovo", "Você gosta de lombriga?"),
				])
				washed_hands = true
			else:
				DialogManager.start_talk([
					DialogInfoModel.new("player", "Mão limpa, barriga seca... Hora de comer!"),
				])
		_:
			if (washed_hands):
				DialogManager.start_talk([
					DialogInfoModel.new("player", "Mão limpa, barriga cheia... Hora de ir cochi-!"),
					DialogInfoModel.new("vovo", "Ir para a escola!"),
				])
			else:
				DialogManager.start_talk([
					DialogInfoModel.new("player", "..."),
					DialogInfoModel.new("vovo", "Esqueceu de lavar as mãos antes de comer, né?"),
					DialogInfoModel.new("vovo", "Depois ta cheia de lombriga e não sabe porquê..."),
				])
