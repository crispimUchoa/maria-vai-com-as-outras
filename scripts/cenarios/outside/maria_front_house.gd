extends Node2D

@onready var go_way_1_post_house = $GoWay1PostHouse
@onready var pai_maria = $PaiMaria

func _ready() -> void:
	go_way_1_post_house.can_go = false
	go_way_1_post_house.alternative_func = func():
		DialogManager.start_talk([
			DialogInfoModel.new("pai_maria", "Vai pedir a bença não, minina?!")
		])

func pedir_benca():
	go_way_1_post_house.can_go = true
