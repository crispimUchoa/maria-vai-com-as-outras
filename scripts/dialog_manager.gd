extends Node
const DIALOG_BOX = preload("res://scenes/dialogBox.tscn")
var current_dialog = null
signal dialog_finished

func is_open():
	return is_instance_valid(current_dialog)

func idTextToDialogModel(line: DialogInfoModel) -> Dictionary:
	return {
		'text': line.text,
		'portrait': get_info(line.id, 'portrait'),
		'display_name': get_info(line.id, 'display_name')
	}

func start_talk(lines: Array[DialogInfoModel]):
	if is_open():
		return
	var dialog_instance = DIALOG_BOX.instantiate()
	current_dialog = dialog_instance
	
	# Criar um CanvasLayer para envelopar a UI do diálogo no topo
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	canvas_layer.add_child(dialog_instance)
	
	get_tree().current_scene.add_child(canvas_layer)
	
	# Remove o CanvasLayer inteiro quando o diálogo fechar
	dialog_instance.tree_exited.connect(
		func():
			current_dialog = null
			dialog_finished.emit()
			canvas_layer.queue_free()
	)
	
	var formated_lines: Array[Dictionary] = []
	for line in lines:
		formated_lines.append(idTextToDialogModel(line))
	
	dialog_instance.setup(formated_lines)

var DIALOGS_INFO: Dictionary[String, DialogModel] = {
	"player": DialogModel.new("Maria",preload("res://sprites/maria/face.png")),
	"vovo": DialogModel.new("Francisca (Vovó)",preload("res://sprites/vovo/face.png")),
	"pai_maria": DialogModel.new("Raimundo (Papai)",preload("res://sprites/pai_maria/idle/down/1.png")),
	"neisso": DialogModel.new("Néisso",preload("res://sprites/neisso/idle/down/1.png")),
	"mae_maria": DialogModel.new("Benedita (Mamãe)",preload("res://sprites/mae_maria/idle/down/1.png")),
	
	
	"filho_7": DialogModel.new("Jenebelso Texeira",preload("res://sprites/familia_7/filho/shoot/down/1.png")),
	"pai_7": DialogModel.new("Juvenal Texeira",preload("res://sprites/familia_7/pai/idle/down/1.png")),
	"mae_7": DialogModel.new("Jurema Texeira",preload("res://sprites/familia_7/mae/idle/down/1.png")),
	"filha_7_1": DialogModel.new("Josilania Texeira",preload("res://sprites/familia_7/filha_1/shoot/down/1.png")),
	"filha_7_2": DialogModel.new("Josilene Texeira",preload("res://sprites/familia_7/filha_2/idle/down/1.png")),
	"filha_7_3": DialogModel.new("Jisenaura Texeira",preload("res://sprites/familia_7/filha_3/shoot/down/1.png")),
	"filha_7_4": DialogModel.new("Joseana Texeira",preload("res://sprites/familia_7/filha_4/idle/down/1.png")),
	"filha_7_5": DialogModel.new("Jiselma Texeira",preload("res://sprites/familia_7/filha_5/idle/down/1.png")),
	"filha_7_6": DialogModel.new("Jisele Texeira",preload("res://sprites/familia_7/filha_6/idle/down/1.png")),
	
	"francisco_anysio": DialogModel.new("Francisco Anysio",preload("res://sprites/familia_anysio/francisco/idle/down/1.png")),
	"socorro_anysio": DialogModel.new("Socorro Anysio",preload("res://sprites/familia_anysio/socorro/idle/down/1.png")),
	"sebastiao_anysio": DialogModel.new("Sebastião Anysio",preload("res://sprites/familia_anysio/sebastiao/idle/down/1.png")),
	"graca_anysio": DialogModel.new("Graça Anysio",preload("res://sprites/familia_anysio/graça/idle/down/1.png")),
	
	"renato_aragao": DialogModel.new("Renato Aragão",preload("res://sprites/renato_aragao/idle/down/1.png")),
	
	
	"padre": DialogModel.new("Padre Ricardo",preload("res://sprites/padre/idle/down/1.png")),
	
	"josefino_neto": DialogModel.new("Josefino Da Silva Souza Neto",preload("res://sprites/josefino_neto/idle/down/1.png")),
	"fazendeiro": DialogModel.new("Josefino Da Silva Souza",preload("res://sprites/fazendeiro/idle/down/1.png")),
		
	"mae_defunta": DialogModel.new("Zumira Costa",preload("res://sprites/mae_defunta/idle/down/1.png")),
	
	
}

func get_info(id: String, key: String):
	# Verifica se o ID existe no dicionário
	if not DIALOGS_INFO.has(id):
		push_warning("ID de diálogo não encontrado: " + id)
		return null
		
	var model: DialogModel = DIALOGS_INFO[id]
	
	# Usa .get() para buscar a propriedade de forma segura no objeto
	return model.get(key)
