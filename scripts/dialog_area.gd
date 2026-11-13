class_name DialogArea extends InteractionArea

@export var dialogs: Array[DialogInfoModel]

func interact():
	if (DialogManager.current_dialog or SceneManager.current): return
	if (dialogs.size() == 0): return
	play_sound()
	set_checkpoint()	
	DialogManager.start_talk(dialogs)
	await DialogManager.dialog_finished
	set_act_actions()	
