extends Node

signal mission_requested
signal change_acess_requested
signal change_daylight_requested

var current_time = 4.5

enum Act {
	ATO_NULO,
	BEGIN_MARIA_HOUSE,
	BEGIN_GO_TO_SCHOOL,
	DEAD_GIRL_WARNING,
	ESPOCA_BUCHO,
	CONSERTE_A_PONTE,
	PROTEJA_SUA_FAMILIA,
	SALVE_SUA_MAE,
	FUNERAL,
	POS_FUNERAL,
	PERSIGUICAO_LOBI,
	INVESTIGAR_MORTE_PAI_E_VO,
	INTIMIDAR_O_PADRE,
	VINGAR_FAMILIA
}

enum Action {
	MERENDAR_COM_A_VO_NO_COMECO,
	PEDIR_BENCA_PRO_PAI_NO_COMECO,
	FAMILIA_ALERTADA,
	FALAR_COM_VOVO_POS_ALERTA,
	VA_COMPRAR_ESPOCA_BUCHO,
	DESMATE_O_BAR,
	ENCONTROU_MAE_MORTA,
	DIALOGO_INICIAL_VELORIO,
	ACHOU_NOTA_IGREJA,
	INVADIR_CASA_DOS_9,
	ACHAR_NOTA_SOBRE_O_PADRE,
	FALAR_PAI_POS_VELORIO,
	VER_LOBI_FUGINDO,
	
}

var actions: Array[Action] = []

const INITIAL_PROGRESS = {
	'current_act': Act.BEGIN_MARIA_HOUSE,
	'current_level': "",
	'current_spawn_id': "",
	'merendou': false,
	'actions': [],
	'mission': "Vá merendar"
}


var current_act: Act = Act.BEGIN_MARIA_HOUSE
var current_level: String = ""
var current_spawn_id: String = ""
var merendou: bool = false
var mission = "Vá merendar"

func update_acess():
	change_acess_requested.emit()
	

func set_act(act: Act):
	current_act = act
	update_acess()
func get_act():
	return current_act

func is_act(act: Act):
	return current_act == act

func reset_progress():
	current_act = Act.BEGIN_MARIA_HOUSE
	current_level = "res://scenes/PlayerBedRoom.tscn"
	current_spawn_id = "InitialSpawn"
	merendou = false
	InventoryManager.items = []
	actions = []
	mission = "Vá merendar"

func load_progress(loaded):
	current_act = loaded["current_act"]
	current_level = loaded["current_level"]
	current_spawn_id = loaded["current_spawn_id"]
	merendou = loaded.get("merendou", false)
	actions = loaded.get("actions", [] as Array[Action])
	mission = loaded.get('mission', "Vá merendar")

func save_progress() -> Dictionary:
	return {
		"current_act": current_act,
		"current_level": current_level,
		"current_spawn_id": current_spawn_id,
		"merendou": merendou,
		"actions": actions,
		"mission": mission
	}

func set_mission(new_mission: String):
	mission = new_mission
	mission_requested.emit(new_mission)

func has_action(action: Action):
	return action in actions

func do_action(action: Action):
	if (!has_action(action)):
		actions.append(action)

func set_time(day_time: float):
	current_time = day_time
	var day_amount = sin((day_time) * PI/24)
	if (day_time > 17):
		day_amount = pow(day_amount, 5*(8 - (day_time - 17))/7)
	var night_amount = (1 - day_amount) * 0.87
	change_daylight_requested.emit(night_amount)

func get_time():
	return current_time
	
func update_light():
	set_time(get_time())
	
