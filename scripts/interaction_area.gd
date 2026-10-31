class_name InteractionArea extends Area2D

signal interacted

func interact():
	if (DialogManager.current_dialog or SceneManager.current): return
	interacted.emit()
