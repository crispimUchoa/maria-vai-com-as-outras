extends CharacterBody2D
class_name Lobisomem

@export_group("Persistência & Identificação")
@export var id_unico: String = ""

@export_group("Configuração de Ato")
@export var atacar_direto: bool = false

@export_group("Atributos de Combate")
@export var vida_maxima: int = 3
@export var item_necessario: String = "machado"
@export var dano_no_player: int = 1

@export_group("Movimentação & Fuga")
@export var velocidade: float = 230.0 
@export var puff_effect_scene: PackedScene = preload("res://scenes/puff_effect.tscn")

var last_direction: Vector2 = Vector2.RIGHT
var path_follow: PathFollow2D = null
var vida_atual: int = 3
var target_player: CharacterBody2D = null
var esta_despistado: bool = false
var velocidade_patrulha: float = 130.0
var capturou_player: bool = false
var em_introducao: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var attack_area: Area2D = $AttackArea

func _ready() -> void:
	if not visibility_changed.is_connected(_on_visibility_changed):
		visibility_changed.connect(_on_visibility_changed)

	# Garante a conexão dos sinais dos nós de visão e ataque
	if detection_area and not detection_area.body_entered.is_connected(_on_detection_area_body_entered):
		detection_area.body_entered.connect(_on_detection_area_body_entered)
		
	if attack_area and not attack_area.body_entered.is_connected(_on_attack_area_body_entered):
		attack_area.body_entered.connect(_on_attack_area_body_entered)

	# Se já iniciou oculto pelo ActGroup, pausa a física e espera ficar visível
	if not is_visible_in_tree():
		set_physics_process(false)
		return
	
	_inicializar_lobisomem()

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		set_physics_process(true)
		_inicializar_lobisomem()
	else:
		set_physics_process(false)
		target_player = null

func _inicializar_lobisomem() -> void:
	vida_atual = vida_maxima
	update_idle_animation()
	
	if get_parent() is PathFollow2D:
		path_follow = get_parent() as PathFollow2D
	
	# Se já foi derrotado/despistado em save anterior
	if id_unico != "" and GameManager.is_objeto_destruido(id_unico):
		if path_follow: 
			path_follow.queue_free()
		else:
			queue_free()
		return

	# Auto-detecção da Maria se recarregar na fuga entre mapas ou no pós-funeral
	if ProgressManager.is_act(ProgressManager.Act.DEAD_GIRL_WARNING) or ProgressManager.is_act(ProgressManager.Act.POS_FUNERAL):
		await get_tree().process_frame
		_buscar_player()

func _physics_process(delta: float) -> void:
	# Trava o movimento em diálogos, cutscenes ou morte
	if em_introducao or capturou_player or DialogManager.is_open() or SceneManager.cutscene_running or esta_despistado:
		velocity = Vector2.ZERO
		update_idle_animation()
		return

	var direction: Vector2 = Vector2.ZERO

	# Estado 1: Perseguição ativa (Correndo atrás da Maria)
	if target_player:
		direction = (target_player.global_position - global_position).normalized()
		velocity = direction * velocidade
		last_direction = direction
		update_run_animation(direction)
		move_and_slide()
	
	# Estado 2: Patrulha no trilho (Andando pelo PathFollow2D)
	elif path_follow:
		var pos_anterior = path_follow.global_position
		path_follow.progress += velocidade_patrulha * delta
		direction = (path_follow.global_position - pos_anterior).normalized()
		
		if direction != Vector2.ZERO:
			last_direction = direction
			update_walk_animation(direction)
		else:
			update_idle_animation()
		
	# Estado 3: Parado
	else:
		velocity = Vector2.ZERO
		update_idle_animation()

func update_run_animation(dir: Vector2) -> void:
	if not animated_sprite:
		return
		
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			animated_sprite.play("run_right")
		else:
			animated_sprite.play("run_left")
	else:
		if dir.y > 0:
			animated_sprite.play("run_down")
		else:
			animated_sprite.play("run_up")

func update_walk_animation(dir: Vector2) -> void:
	if not animated_sprite:
		return
		
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			animated_sprite.play("walk_right")
		else:
			animated_sprite.play("walk_left")
	else:
		if dir.y > 0:
			animated_sprite.play("walk_down")
		else:
			animated_sprite.play("walk_up")

func update_idle_animation() -> void:
	if not animated_sprite:
		return
		
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			animated_sprite.play("idle_right")
		else:
			animated_sprite.play("idle_left")
	else:
		if last_direction.y > 0:
			animated_sprite.play("idle_down")
		else:
			animated_sprite.play("idle_up")
			
func _buscar_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target_player = players[0] as CharacterBody2D
	else:
		var player_node = get_tree().current_scene.find_child("Maria", true, false)
		if not player_node:
			player_node = get_tree().current_scene.find_child("Player", true, false)
		if player_node is CharacterBody2D:
			target_player = player_node

func _on_detection_area_body_entered(body: Node2D) -> void:
	if not is_visible_in_tree():
		return
		
	if body is Player:
		var ato_valido = ProgressManager.is_act(ProgressManager.Act.DEAD_GIRL_WARNING) or ProgressManager.is_act(ProgressManager.Act.POS_FUNERAL)
		if ato_valido and not em_introducao and target_player == null:
			target_player = body as CharacterBody2D
			if not atacar_direto:
				iniciar_interacao_inicial()

func iniciar_interacao_inicial() -> void:
	em_introducao = true
	velocity = Vector2.ZERO
	
	if path_follow and is_instance_valid(path_follow):
		var pos_global = global_position
		var mapa_raiz = path_follow.get_parent().get_parent()
		reparent(mapa_raiz)
		global_position = pos_global
		path_follow = null
	
	await get_tree().create_timer(1.0).timeout
	em_introducao = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	if not is_visible_in_tree():
		return
	# Só ataca se estiver perseguindo o player ativamente
	if body is Player and target_player != null and not capturou_player and not esta_despistado:
		capturou_player = true
		velocity = Vector2.ZERO
		
		if body.has_method("receber_dano_fatal"):
			body.receber_dano_fatal()
		elif body.has_method("take_damage"):
			body.take_damage(dano_no_player)

func take_damage(damage: int = 1) -> void:
	if not InventoryManager.has_item(item_necessario):
		if not DialogManager.is_open():
			DialogManager.start_talk([
				DialogInfoModel.new('player', 'Minha Nossa Senhora, eu não tenho nem um pau pra dar nele!')
			])
		return
	
	vida_atual -= damage
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

func despistar() -> void:
	if esta_despistado or capturou_player:
		return
		
	esta_despistado = true
	target_player = null
	velocity = Vector2.ZERO
	
	if id_unico != "":
		GameManager.registrar_objeto_destruido(id_unico)
		
	if not DialogManager.is_open():
		DialogManager.start_talk([
			DialogInfoModel.new('player', 'Vala meu Deus! Consegui dar um arrudeio na fera!')
		])
	
	gerar_puffeffect()
	queue_free()

func gerar_puffeffect() -> void:
	if puff_effect_scene:
		var puff = puff_effect_scene.instantiate()
		puff.global_position = global_position
		get_parent().add_child(puff)
