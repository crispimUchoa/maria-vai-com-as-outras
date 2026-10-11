class_name InteractionArea extends Area2D

signal interacted

func interact():
	interacted.emit()
