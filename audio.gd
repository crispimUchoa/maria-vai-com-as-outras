extends Node

var current_sound: AudioStreamPlayer

func tocar(caminho: String, stopable: bool = false):
	var player = AudioStreamPlayer.new()
	player.stream = load(caminho)
	
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
	
	if stopable:
		current_sound = player
		# Limpa a variável automaticamente apenas quando ESTE som acabar naturalmente
		player.finished.connect(func(): 
			if current_sound == player: 
				current_sound = null
		)

func parar():
	if is_instance_valid(current_sound):
		current_sound.stop()
		current_sound.queue_free()
		current_sound = null # Limpa a variável após forçar a parada
