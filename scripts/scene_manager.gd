extends Node

signal level_change_requested(next_level_path: String, next_spawn_id: String)
signal cutscene_finished

var current: Node = null

func change_level(next_level_path: String, next_spawn_id: String) -> void:
	level_change_requested.emit(next_level_path, next_spawn_id)
	ProgressManager.current_level = next_level_path
	ProgressManager.current_spawn_id = next_spawn_id

func show_cutscene(scene_path: String, animation: String, timer: float = -1.0) -> void:
	if get_tree() == null:
		return

	# Se a cutscene já está na tela, apenas trocamos a animação/quadro!
	if is_instance_valid(current):
		var cutscene_sprite: AnimatedSprite2D = current.get_child(0) as AnimatedSprite2D
		if cutscene_sprite:
			cutscene_sprite.play(animation)
			
		if timer > 0:
			await get_tree().create_timer(timer, true, false, true).timeout
			cutscene_finished.emit()
		
		return

	# Caso contrário, instancia do zero
	var cutscene_node = load(scene_path)
	if not cutscene_node:
		push_error("Erro ao carregar a cutscene: " + scene_path)
		return

	current = cutscene_node.instantiate()
	current.process_mode = Node.PROCESS_MODE_ALWAYS # Garante funcionamento durante o Pause
	get_tree().current_scene.add_child(current)
	

	var cutscene: AnimatedSprite2D = current.get_child(0) as AnimatedSprite2D
	if cutscene:
		cutscene.play(animation)

	if timer > 0:
		# Timer que roda mesmo com o jogo pausado (process_always = true)
		await get_tree().create_timer(timer, true, false, true).timeout
		cutscene_finished.emit()

func stop_cutscene() -> void:
	if is_instance_valid(current):
		current.queue_free()
		current = null
		
		
	cutscene_finished.emit()
