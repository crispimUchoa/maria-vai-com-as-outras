extends Node
const DIALOG_BOX = preload("res://scenes/dialogBox.tscn")
var current_dialog = null
func start_talk(character: Node2D, text: String):
	if is_instance_valid(current_dialog):
		return
	var dialog_instance = DIALOG_BOX.instantiate()
	current_dialog = dialog_instance
	get_tree().current_scene.add_child(dialog_instance)
	
	dialog_instance.setup(text, character.portrait)
