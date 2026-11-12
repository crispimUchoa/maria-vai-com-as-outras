extends AnimatedSprite2D
class_name AnimalLoop

@export var nome_animacao: String = "default"
@export var dessincronizar_inicio: bool = true
@export var variacao_velocidade: bool = true

func _ready() -> void:
	# Toca a animação configurada (ou a primeira disponível caso o nome seja diferente)
	if sprite_frames:
		if sprite_frames.has_animation(nome_animacao):
			play(nome_animacao)
		elif sprite_frames.get_animation_names().size() > 0:
			play(sprite_frames.get_animation_names()[0])
		
		# Varia levemente a velocidade entre cada animal (ex: 0.85x a 1.15x)
		if variacao_velocidade:
			speed_scale = randf_range(0.85, 1.15)
			
		# Inicia em um quadro aleatório para as galinhas não bicarem ao mesmo tempo
		if dessincronizar_inicio:
			var total_frames = sprite_frames.get_frame_count(animation)
			if total_frames > 0:
				frame = randi() % total_frames
