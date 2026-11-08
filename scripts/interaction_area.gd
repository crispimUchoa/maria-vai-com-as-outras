class_name InteractionArea extends Area2D

@export var actions: Array[ProgressManager.Action] = []
@export var next_act: ProgressManager.Act = ProgressManager.Act.BEGIN_MARIA_HOUSE
signal interacted

func set_act_actions():
	if (not ProgressManager.is_act(next_act) and not next_act == ProgressManager.Act.BEGIN_MARIA_HOUSE):
		ProgressManager.set_act(next_act)
		print('ola')
	
	for action in actions:
		ProgressManager.do_action(action)

func interact():
	if (DialogManager.current_dialog or SceneManager.current): return
	interacted.emit()
	set_act_actions()
	
