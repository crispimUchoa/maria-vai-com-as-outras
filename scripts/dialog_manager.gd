extends Node
const DIALOG_BOX = preload("res://scenes/dialogBox.tscn")
var current_dialog = null

func is_open():
	return is_instance_valid(current_dialog)

func idTextToDialogModel(line: DialogInfoModel) -> Dictionary:
	return {
		'text': line.text,
		'portrait': get_info(line.id, 'portrait')
	}

func start_talk(lines: Array[DialogInfoModel]): # {id, text}
	if is_open():
		return
	var dialog_instance = DIALOG_BOX.instantiate()
	current_dialog = dialog_instance
	get_tree().current_scene.add_child(dialog_instance)
	
	# No dialog_manager.gd, altere a linha do map para:
	var formated_lines: Array[Dictionary] = []
	for line in lines:
		formated_lines.append(idTextToDialogModel(line))
	
	dialog_instance.setup(formated_lines)

var DIALOGS_INFO: Dictionary[String, DialogModel] = {
	"player": DialogModel.new("Maria",preload("res://sprites/player/face.png"))
}

func get_info(id: String, key: String):
	# Verifica se o ID existe no dicionário
	if not DIALOGS_INFO.has(id):
		push_warning("ID de diálogo não encontrado: " + id)
		return null
		
	var model: DialogModel = DIALOGS_INFO[id]
	
	# Usa .get() para buscar a propriedade de forma segura no objeto
	return model.get(key)
