extends CharacterBody2D

@onready var sound: AudioStreamPlayer2D = $som_puff
@onready var animated_sprite: AnimatedSprite2D = $fumaca

func _ready() -> void:
	if sound and sound.stream:
		sound.play()
	
	if animated_sprite:
		# Conecta o fim da animação do nó filho ao descarte da cena
		if not animated_sprite.animation_finished.is_connected(_on_animation_finished):
			animated_sprite.animation_finished.connect(_on_animation_finished)
		
		# Toca a animação "fumaca" no nó filho
		if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("fumaca"):
			animated_sprite.play("fumaca")
		else:
			animated_sprite.play()

func _on_animation_finished() -> void:
	# Se o som ainda estiver tocando, esconde o visual e aguarda o som terminar
	if sound and sound.playing:
		visible = false
		sound.finished.connect(queue_free)
	else:
		queue_free()
