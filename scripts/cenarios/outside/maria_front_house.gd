extends Node2D

@onready var go_way_1_post_house = $GoWay1PostHouse
const pediu_benca: ProgressManager.Action = ProgressManager.Action.PEDIR_BENCA_PRO_PAI_NO_COMECO

func _ready() -> void:
	go_way_1_post_house.can_go = (ProgressManager.has_action(pediu_benca) or 
	ProgressManager.get_act() >= ProgressManager.Act.DEAD_GIRL_WARNING)
	go_way_1_post_house.alternative_func = func():
		DialogManager.start_talk([
			DialogInfoModel.new("pai_maria", "Vai pedir a bença não, minina?!")
		])

func pedir_benca():
	go_way_1_post_house.can_go = true
	ProgressManager.do_action(pediu_benca)
