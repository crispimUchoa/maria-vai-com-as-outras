extends ColorRect

func set_night_intensity(amount: float) -> void:
	# Clamp para garantir que fique entre 0.0 e 1.0
	amount = clamp(amount, 0.0, 1.0)
	(material as ShaderMaterial).set_shader_parameter("night_amount", amount)

# Exemplo: Transição suave de 2 segundos para a noite usando Tween
func transition_to_night() -> void:
	var mat = material as ShaderMaterial
	var tween = create_tween()
	tween.tween_method(
		func(val: float): mat.set_shader_parameter("night_amount", val),
		0.0, # Do dia
		0.75, # Para a noite
		2.0  # Duração em segundos
	)
