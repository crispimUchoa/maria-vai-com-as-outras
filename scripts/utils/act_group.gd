class_name ActGroup extends Node2D

@export var min_act: ProgressManager.Act = ProgressManager.Act.BEGIN_MARIA_HOUSE
@export var max_act: ProgressManager.Act = ProgressManager.Act.ATO_NULO

@export var needed_actions: Dictionary[ProgressManager.Action, bool]

@export var needed_items: Dictionary[String, bool]
@export var appear_mode: bool = true
@export var always_visible: bool = false
@export var use_act_inverval: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (max_act == ProgressManager.Act.ATO_NULO):
		max_act = ProgressManager.Act.values()[-1]
	ProgressManager.change_acess_requested.connect(update_acess)
	
	set_acess()

func update_acess():
	set_acess()

func is_needed_action_done(action: ProgressManager.Action):
	return needed_actions[action] == ProgressManager.has_action(action)
	
func is_all_needed_actions_done():
	return needed_actions.keys().all(is_needed_action_done)

func is_item_done(item: String):
	return needed_items[item] == InventoryManager.has_item(item)
	
func is_all_items_done():
	print("ALL ITEMS ", needed_items.keys().all(is_item_done))
	return needed_items.keys().all(is_item_done)

func is_in_act_interval():
	if (not use_act_inverval): return true
	var current_act = ProgressManager.get_act()
	return (min_act <= current_act and max_act >= current_act)

func can_acess():
	print(name, ' ', is_all_needed_actions_done() )
	
	return ( is_in_act_interval()
	and is_all_needed_actions_done() and is_all_items_done())

func set_acess():
	if (max_act < min_act): 
		push_error("Max act must be higher or equal than min act.")
	var active: bool = (can_acess() == appear_mode)
	if (active):
		process_mode = Node.PROCESS_MODE_INHERIT
		visible = true or always_visible
	else:
		visible = false or always_visible
		process_mode = Node.PROCESS_MODE_DISABLED
	_set_collisions_recursive(self, active or always_visible)
	
func _set_collisions_recursive(node: Node, enabled: bool) -> void:
	for child in node.get_children():

		if child is TileMapLayer:
			child.collision_enabled = enabled
				
		# Percorre os nós filhos recursivamente
		if child.get_child_count() > 0:
			_set_collisions_recursive(child, enabled)
