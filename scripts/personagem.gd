@tool
extends StaticBody2D

@export var sprite_frames: SpriteFrames:
	set(value):
		sprite_frames = value
		# Atualiza o sprite imediatamente no editor quando você troca o recurso no Inspector
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.sprite_frames = value

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Garante que o recurso será aplicado ao rodar o jogo 
	# (caso o setter tenha rodado antes do nó filho estar pronto)
	if sprite_frames:
		animatedSprite.sprite_frames = sprite_frames
