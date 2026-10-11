extends Node2D

@onready var player: CharacterBody2D = $Player

var initial_dialogs: Array[DialogInfoModel] = [
	DialogInfoModel.new("player", "Minha Nossa Senhora, que sono miseravi..."),
	DialogInfoModel.new('player',  "Ainda bem que é sexta, não aguento mais ver a lata das pestes da minha escola...")
]


func _ready() -> void:	
	print("Sistema inicializado com sucesso!")
	DialogManager.start_talk(initial_dialogs)
	
