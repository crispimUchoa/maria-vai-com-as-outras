class_name InteractionArea extends Area2D

@export var actions: Array[ProgressManager.Action] = []
@export var items: Array[String] = []
@export var next_act: ProgressManager.Act = ProgressManager.Act.BEGIN_MARIA_HOUSE
@export var autoInteract: bool = false:
	set(value):
		autoInteract = value
		_atualizar_conexao()
@export var next_mission: String = ""
@export var next_time: float = -1
@export_file("*.wav", "*.mp3", "*.ogg") var sound: String
@export var auto_destroy = false

@export_group("Checkpoint")
@export var is_checkpoint: bool = false
@export var spawn_id: String
@export_file(".tscn") var scene_file: String

signal interacted

func set_checkpoint():
	if (not is_checkpoint or not scene_file or not spawn_id): return
	ProgressManager.current_level = scene_file
	ProgressManager.current_spawn_id = spawn_id
	GameManager.salvar_jogo(global_position)

func _ready() -> void:
	_atualizar_conexao()

func on_area_entered(body: Node) -> void:
	print("BODY ENTERED: ", body.name)
	# Verifica se o nó que entrou pertence ao grupo "Player"
	if body.is_in_group("PlayerArea"):
		interact()

func play_sound():
	if (sound):
		Audio.tocar(sound)			

func set_act_actions():
	if (not ProgressManager.is_act(next_act) and not next_act == ProgressManager.Act.BEGIN_MARIA_HOUSE):
		ProgressManager.set_act(next_act)
	
	for action in actions:
		ProgressManager.do_action(action)
	
	for item in items:
		if (not InventoryManager.has_item(item)):
			InventoryManager.add_item(item)
	
	if (not next_mission.is_empty()):
		print(next_mission)
		ProgressManager.set_mission(next_mission)
	
	if (next_time >= 0):
		ProgressManager.set_time(next_time)
	
	
	ProgressManager.update_acess()
	if (auto_destroy):
		queue_free()

func interact():
	if (DialogManager.current_dialog or SceneManager.current): return
	play_sound()
	set_checkpoint()
	interacted.emit()
	set_act_actions()

func _atualizar_conexao() -> void:
	if autoInteract:
		if not area_entered.is_connected(on_area_entered):
			area_entered.connect(on_area_entered)
	else:
		if area_entered.is_connected(on_area_entered):
			area_entered.disconnect(on_area_entered)
