extends CharacterBody2D
class_name Lobisomem

@export_group("Persistência & Identificação")
@export var id_unico: String = "" # "lobisomem_boss"

@export_group("Atributos de Combate")
@export var vida_maxima: int = 3
@export var item_necessario: String = "machado"
@export var dano_no_player: int = 1

@export_group("Movimentação & Fuga")
@export var velocidade: float = 140.0 # Ajuste para ser proporcional à velocidade da Maria
@export var puff_effect_scene: PackedScene = preload("res://scenes/puff_effect.tscn")

var vida_atual: int = 3
var target_player: CharacterBody2D = null
var esta_despistado: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	vida_atual = vida_maxima
	
	# Se já foi derrotado/despistado em um save anterior, remove do mapa
	if id_unico != "" and GameManager.is_objeto_destruido(id_unico):
		queue_free()

func _physics_process(_delta: float) -> void:
	# Trava o movimento em diálogos, cutscenes ou se já tiver sido despistado/derrotado
	if DialogManager.is_open() or SceneManager.cutscene_running or esta_despistado:
		velocity = Vector2.ZERO
		return

	# Lógica de perseguição
	if target_player:
		var direcao: Vector2 = (target_player.global_position - global_position).normalized()
		velocity = direcao * velocidade
		
		# Animações de corrida/caminhada e espelhamento do sprite
		if animated_sprite:
			if animated_sprite.sprite_frames.has_animation("run"):
				animated_sprite.play("run")
			elif animated_sprite.sprite_frames.has_animation("walk"):
				animated_sprite.play("walk")
			
			animated_sprite.flip_h = (direcao.x < 0)
	else:
		velocity = Vector2.ZERO
		if animated_sprite and animated_sprite.sprite_frames.has_animation("idle"):
			animated_sprite.play("idle")

	move_and_slide()

# --- SINAIS DE DETECÇÃO (Perseguição) ---

# Conecte o sinal body_entered da Area2D de visão aqui
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "Maria":
		target_player = body

# Conecte o sinal body_exited da Area2D de visão aqui
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target_player:
		target_player = null

# --- MECÂNICA DE DANO & COMBATE (Acionado pela AxeHitbox) ---

func take_damage(damage: int = 1) -> void:
	# Valida se Maria tem o machado no inventário
	if not InventoryManager.has_item(item_necessario):
		if not DialogManager.is_open():
			DialogManager.start_talk([
				DialogInfoModel.new('Maria', 'A arma normal não faz nem cócega nele! Preciso do machado!')
			])
		return
	
	vida_atual -= damage
	print("Lobisomem atingido! Vida restante: ", vida_atual)
	
	piscar_dano()
	
	if vida_atual <= 0:
		derrotar()

func piscar_dano() -> void:
	if animated_sprite:
		var tween = create_tween()
		tween.tween_property(animated_sprite, "modulate", Color.RED, 0.1)
		tween.tween_property(animated_sprite, "modulate", Color.WHITE, 0.1)

func derrotar() -> void:
	if id_unico != "":
		GameManager.registrar_objeto_destruido(id_unico)
	
	gerar_puffeffect()
	queue_free()

# --- MECÂNICA DE DESPISTAR / FUGA (Opcional via Safe Zone) ---

func despistar() -> void:
	if esta_despistado:
		return
		
	esta_despistado = true
	target_player = null
	velocity = Vector2.ZERO
	
	if id_unico != "":
		GameManager.registrar_objeto_destruido(id_unico)
		
	if not DialogManager.is_open():
		DialogManager.start_talk([
			DialogInfoModel.new('Maria', 'Valha-me Deus! Consegui despistar essa fera!')
		])
	
	gerar_puffeffect()
	queue_free()

func gerar_puffeffect() -> void:
	if puff_effect_scene:
		var puff = puff_effect_scene.instantiate()
		puff.global_position = global_position
		get_parent().add_child(puff)
