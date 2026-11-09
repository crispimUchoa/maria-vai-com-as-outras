extends StaticBody2D
class_name DestroiObjeto

@export var id_unico: String = ""
@export var required_item: String = "machado"
@export var puff_effect_scene: PackedScene = preload("res://scenes/puff_effect.tscn")

func _ready() -> void:
	# Se a cerca já foi destruída, remove ela no início da cena
	if id_unico != "" and GameManager.is_objeto_destruido(id_unico):
		queue_free()

func take_damage(_amount: int = 1) -> void:
	quebrar()

func quebrar() -> void:
	if not InventoryManager.has_item(required_item):
		if not DialogManager.is_open():
			DialogManager.start_talk([
				DialogInfoModel.new('player', 'Ah inferno pra tê cão! Não dá pra eu passar!!!'),
				DialogInfoModel.new('player', 'Vou ter que encontrar um machado')
			])
		return
		
	if id_unico != "":
		GameManager.registrar_objeto_destruido(id_unico)
	
	gerar_puffeffect()
	queue_free()

func gerar_puffeffect() -> void:
	if puff_effect_scene:
		var puff = puff_effect_scene.instantiate()
		puff.global_position = global_position
		get_parent().add_child(puff)
