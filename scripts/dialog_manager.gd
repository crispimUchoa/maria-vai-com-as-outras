extends Node
const DIALOG_BOX = preload("res://scenes/dialogBox.tscn")
var current_dialog = null
signal dialog_finished

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
	dialog_instance.tree_exited.connect(
		func():
			current_dialog=null
			dialog_finished.emit() 
			)
	# No dialog_manager.gd, altere a linha do map para:
	var formated_lines: Array[Dictionary] = []
	for line in lines:
		formated_lines.append(idTextToDialogModel(line))
	
	dialog_instance.setup(formated_lines)

var DIALOGS_INFO: Dictionary[String, DialogModel] = {
	"player": DialogModel.new("Maria",preload("res://sprites/maria/face.png")),
	"vovo": DialogModel.new("Vovó Chiquinha",preload("res://sprites/vovo/face.png")),
	"pai_maria": DialogModel.new("Pai Maria",preload("res://sprites/pai_maria/idle/down/1.png")),
}

func get_info(id: String, key: String):
	# Verifica se o ID existe no dicionário
	if not DIALOGS_INFO.has(id):
		push_warning("ID de diálogo não encontrado: " + id)
		return null
		
	var model: DialogModel = DIALOGS_INFO[id]
	
	# Usa .get() para buscar a propriedade de forma segura no objeto
	return model.get(key)
