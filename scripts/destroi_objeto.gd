extends StaticBody2D
class_name DestroiObjeto

@export var required_item: String = "machado"
@export var puff_effect_scene: PackedScene = preload("res://scenes/puff_effect.tscn")

func  take_damage(_amount: int = 1) -> void:
	quebrar()
	
func quebrar() -> void:
	if not InventoryManager.has_item(required_item):
		DialogManager.start_talk([
			DialogInfoModel.new('player', 'Ah inferno pra tê cão! Não dá pra eu passar!!!'),
			DialogInfoModel.new('player', 'Vou ter que encontrar um machado')
		])
		return
		
	gerar_puffeffect()
	queue_free()
	
func gerar_puffeffect() -> void:
	if puff_effect_scene:
		var puff = puff_effect_scene.instantiate()
		puff.global_position = global_position
		get_parent().add_child(puff)
