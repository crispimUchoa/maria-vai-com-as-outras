extends CharacterBody2D
class_name Lobisomem

@export_group("Persistência & Identificação")
@export var id_unico: String = ""

@export_group("Atributos de Combate")
@export var vida_maxima: int = 3
@export var item_necessario: String = "machado"
@export var dano_no_player: int = 1

@export_group("Movimentação & Fuga")
@export var velocidade: float = 230.0 
@export var puff_effect_scene: PackedScene = preload("res://scenes/puff_effect.tscn")

var ultima_direcao: Vector2 = Vector2.DOWN
var path_follow: PathFollow2D = null
var vida_atual: int = 3
var target_player: CharacterBody2D = null
var esta_despistado: bool = false
var velocidade_patrulha = 130.0
var capturou_player: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	vida_atual = vida_maxima
	
	# verifica se foi instanciado dentro de um path follow
	if get_parent() is PathFollow2D:
		path_follow = get_parent() as PathFollow2D
	
	# Se já foi derrotado/despistado em um save anterior, remove do mapa
	if id_unico != "" and GameManager.is_objeto_destruido(id_unico):
		if path_follow: 
			path_follow.queue_free()
		else:
			queue_free()

func _physics_process(delta: float) -> void:
	# Trava o movimento em diálogos, cutscenes ou se já tiver sido despistado/derrotado
	if DialogManager.is_open() or SceneManager.cutscene_running or esta_despistado:
		velocity = Vector2.ZERO
		return

	# estado de perseguição a maria
	if target_player:
		var direcao: Vector2 = (target_player.global_position - global_position).normalized()
		velocity = direcao * velocidade
		
		atualizar_animacao(direcao)
		move_and_slide()
	
	#estado de patrulhamento ao longo do pathfollow2D
	elif path_follow:
		var pos_anterior = path_follow.global_position
		path_follow.progress += velocidade_patrulha * delta
		
		var deslocamento = path_follow.global_position - pos_anterior
		atualizar_animacao(deslocamento)
		
	#estado parado no lugar
	else:
		velocity = Vector2.ZERO
		atualizar_animacao(Vector2.ZERO)
		
func atualizar_animacao(direcao: Vector2) -> void:
	if not animated_sprite:
		return
	
	animated_sprite.flip_h = false

	if direcao.length() > 0.1:
		ultima_direcao = direcao
		var sufixo_direcao: String = obter_sufixo_direcao(direcao)
		
		if target_player:
			if animated_sprite.sprite_frames.has_animation("run_" + sufixo_direcao):
				animated_sprite.play("run_" + sufixo_direcao)
			else:
				animated_sprite.play("walk_" + sufixo_direcao)
		
		else:
			animated_sprite.play("walk_" + sufixo_direcao)
	else:
		
		var sufixo_direcao: String = obter_sufixo_direcao(ultima_direcao)
		animated_sprite.play("idle_" + sufixo_direcao)

# Função auxiliar p/ direção
func obter_sufixo_direcao(dir: Vector2) -> String:
	if abs(dir.x) > abs(dir.y):
		return "right" if dir.x > 0 else "left"
	else:
		return "down" if dir.y > 0 else "up"
	
# SINAIS DE DETECÇÃO (Perseguição)
# Conecte o sinal body_entered da Area2D de visão aqui
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "Player":
		target_player = body
		
		# se tiver em um trilho "desacopla" pra andar atras da maria
		if path_follow and is_instance_valid(path_follow):
			var pos_global = global_position
			var mapa_raiz = path_follow.get_parent().get_parent()
			reparent(mapa_raiz)
			global_position = pos_global
			path_follow = null 

# Conecte o sinal body_exited da Area2D de visão aqui
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == target_player:
		target_player = null
		
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name == "player" and not capturou_player and not esta_despistado:
		capturou_player = true
		velocity = Vector2.ZERO
		
		# Notifica o script da Maria sobre o ataque
		if body.has_method("receber_dano_fatal"):
			body.receber_dano_fatal()
		elif body.has_method("take_damage"):
			body.take_damage(dano_no_player)

# MECÂNICA DE DANO & COMBATE (Acionado pela AxeHitbox) 
func take_damage(damage: int = 1) -> void:
	if not InventoryManager.has_item(item_necessario):
		if not DialogManager.is_open():
			DialogManager.start_talk([
				DialogInfoModel.new('player', 'Minha Nossa Senhora, eu não tenho nem um pau pra dar nele!')
			])
		return
	
	vida_atual -= damage
	print("Lobisomem atingido! Vida restante: ", vida_atual)
	
	piscar_dano()
	
	if vida_atual <= 0:
		derrotar()

func piscar_dano() -> void:
	if animated_sprite:
		var interpolar = create_tween()
		interpolar.tween_property(animated_sprite, "modulate", Color.RED, 0.1)
		interpolar.tween_property(animated_sprite, "modulate", Color.WHITE, 0.1)

func derrotar() -> void:
	if id_unico != "":
		GameManager.registrar_objeto_destruido(id_unico)
	
	gerar_puffeffect()
	queue_free()

# MECÂNICA DE DESPISTAR FUGIR

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
			DialogInfoModel.new('Maria', 'Vala meu Deus! Consegui dar um arrudeio na fera!')
		])
	
	gerar_puffeffect()
	queue_free()

func gerar_puffeffect() -> void:
	if puff_effect_scene:
		var puff = puff_effect_scene.instantiate()
		puff.global_position = global_position
		get_parent().add_child(puff)
