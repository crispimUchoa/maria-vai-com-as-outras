extends Node2D

@export var min_act: ProgressManager.Act = ProgressManager.Act.BEGIN_MARIA_HOUSE
@export var max_act: ProgressManager.Act = ProgressManager.Act.values()[-1]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressManager.change_acess_requested.connect(update_acess)
	
	set_acess()

func update_acess():
	set_acess()

func set_acess():
	if (max_act <= min_act): 
		push_error("Max act must be higher than min act.")
	var current_act = ProgressManager.get_act()
	if (min_act <= current_act and max_act >= current_act):
		process_mode = Node.PROCESS_MODE_INHERIT
		visible = true
	else:
		visible = false
		process_mode = Node.PROCESS_MODE_DISABLED
	
