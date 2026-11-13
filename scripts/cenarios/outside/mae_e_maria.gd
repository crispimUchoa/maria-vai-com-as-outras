extends Node2D

# Recebe uma string e devolve um dialogModelInfo do Player
func pd(text: String):
	return DialogInfoModel.new('player', text)

func _on_interaction_area_interacted() -> void:
	SceneManager.show_cutscene("res://scenes/cutscenes/mae_e_maria.tscn","0")
	DialogManager.start_talk([
		pd("MÃAAAAAAAAAAAAAAAAAAAAAAAE!"),
		pd("NÃO PODE SER! MÃE REAGE, POR FAVOR!"),
		pd("ALGUÉM! ALGUÉM AJUDA MINHA MÃE!"),
		pd("POR FAVOR! POR FAVOR! DEUS, POR FAVOR, SALVA MINHA MÃE!"),
		pd("MEU SENHOR! POR FAVOR!"),
	])
	await DialogManager.dialog_finished
	
	SceneManager.show_cutscene("res://scenes/cutscenes/mae_e_maria.tscn","1", 1.0)
	await SceneManager.cutscene_finished
	DialogManager.start_talk([
		pd("NÃAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAO!"),
	])
	await DialogManager.dialog_finished
	SceneManager.show_cutscene("res://scenes/cutscenes/mae_e_maria.tscn","1", 1.0)
	await SceneManager.cutscene_finished
	ProgressManager.set_time(18.0)
	SceneManager.stop_cutscene()
	SceneManager.change_level('res://scenes/cenarios/outside/village_3.tscn', 'SpawnFuneral')
	ProgressManager.set_act(ProgressManager.Act.FUNERAL)
