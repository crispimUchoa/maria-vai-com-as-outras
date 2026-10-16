extends Node2D

@onready var go_to_parents = $GoToParentsBedRoom
@onready var go_to_outside = $GoToOutside

func can_not_go_parents_bedroom():
	go_to_parents.can_go = false
	go_to_parents.alternative_func = func():
		DialogManager.start_talk([
		DialogInfoModel.new('player', 'Tô atrasada, melhor não perder tempo aqui...')
		])
		
func _ready() -> void:
	match ProgressManager.current_act:
		ProgressManager.Act.BEGIN_MARIA_HOUSE:
			can_not_go_parents_bedroom()
			
			go_to_outside.can_go = false
			go_to_outside.alternative_func = func():
				DialogManager.start_talk([
					DialogInfoModel.new('player', 'Que fome...'),
					DialogInfoModel.new('player', 'Cuidar ver o que é a merenda.'),
				])
		ProgressManager.Act.BEGIN_GO_TO_SCHOOL:
			can_not_go_parents_bedroom()
