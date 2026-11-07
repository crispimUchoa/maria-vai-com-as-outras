extends AnimatedSprite2D

@onready var sound: AudioStreamPlayer2D = $som_puff

func _ready() -> void:
	if sound and sound.stream:
		sound.play()
		$AnimatedSprite2D.play("puff")
		$AnimatedSprite2D.animation_finished.connect(queue_free)
