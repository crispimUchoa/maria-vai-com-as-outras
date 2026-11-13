class_name InteractionArea extends Area2D

@export var actions: Array[ProgressManager.Action] = []
@export var items: Array[String] = []
@export var next_act: ProgressManager.Act = ProgressManager.Act.BEGIN_MARIA_HOUSE
@export var autoInteract = false
@export var next_mission: String = ""
@export var next_time: float = -1
@export_file("*.wav", "*.mp3", "*.ogg") var sound: String
@export var auto_destroy = false
signal interacted


func _ready() -> void:
	# Conecta o sinal de entrada de corpos à função de tratamento
	if (autoInteract):
		area_entered.connect(on_area_entered)

func on_area_entered(body: Node) -> void:
	print("BODY ENTERED: ", body.name)
	# Verifica se o nó que entrou pertence ao grupo "Player"
	if body.is_in_group("PlayerArea"):
		interact()


func set_act_actions():
	if (not ProgressManager.is_act(next_act) and not next_act == ProgressManager.Act.BEGIN_MARIA_HOUSE):
		ProgressManager.set_act(next_act)
	
	for action in actions:
		ProgressManager.do_action(action)
	
	for item in items:
		if (not InventoryManager.has_item(item)):
			InventoryManager.add_item(item)
	
	if (not next_mission.is_empty()):
		ProgressManager.set_mission(next_mission)
	
	if (next_time >= 0):
		ProgressManager.set_time(next_time)
	
	if (sound):
		Audio.tocar(sound)
	ProgressManager.update_acess()
	if (auto_destroy):
		queue_free()

func interact():
	if (DialogManager.current_dialog or SceneManager.current): return
	interacted.emit()
	set_act_actions()
	
