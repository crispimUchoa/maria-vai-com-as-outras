extends CharacterBody2D
class_name Lobisomem

@export_group("Persistência & Identificação")
@export var id_unico: String = ""

@export_group("Configuração de Ato")
@export var atacar_direto: bool = false # true na hit-kill do bar
@export var modo_confronto_final: bool = false
@export var pontos_reposicionamento: Array[NodePath] = []

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
var recuando: bool = false
var ponto_recuo_atual: Vector2 = Vector2.ZERO
var empurrao: bool = false
var empurrao_velocity: Vector2 = Vector2.ZERO
var pode_atacar: bool = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var attack_area: Area2D = $AttackArea

func _ready() -> void:
	if not visibility_changed.is_connected(_on_visibility_changed):
		visibility_changed.connect(_on_visibility_changed)

	if detection_area and not detection_area.body_entered.is_connected(_on_detection_area_body_entered):
		detection_area.body_entered.connect(_on_detection_area_body_entered)
		
	if attack_area and not attack_area.body_entered.is_connected(_on_attack_area_body_entered):
		attack_area.body_entered.connect(_on_attack_area_body_entered)

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
	
	if id_unico != "" and GameManager.is_objeto_destruido(id_unico):
		if path_follow: 
			path_follow.queue_free()
		else:
			queue_free()
		return

	if not modo_confronto_final:
		if ProgressManager.is_act(ProgressManager.Act.DEAD_GIRL_WARNING) or ProgressManager.is_act(ProgressManager.Act.POS_FUNERAL):
			await get_tree().process_frame
			_buscar_player()

func _physics_process(delta: float) -> void:
	if em_introducao or capturou_player or DialogManager.is_open() or SceneManager.cutscene_running or esta_despistado:
		velocity = Vector2.ZERO
		update_idle_animation()
		return
		
	# 1. Estado de Knockback (afastado levemente ao levar machadada)
	if empurrao:
		velocity = empurrao_velocity
		empurrao_velocity = empurrao_velocity.move_toward(Vector2.ZERO, 900.0 * delta)
		move_and_slide()
		if empurrao_velocity.length() < 15.0:
			empurrao = false
			iniciar_recuo_tatico()
		return

	# 2. Estado de Recuo (correndo para outro ponto da cena antes de recomeçar o ataque)
	if recuando:
		var dir_recuo = (ponto_recuo_atual - global_position).normalized()
		velocity = dir_recuo * (velocidade * 1.15)
		last_direction = dir_recuo
		update_run_animation(dir_recuo)
		move_and_slide()
		
		if global_position.distance_to(ponto_recuo_atual) < 16.0 or is_on_wall():
			recuando = false
			await get_tree().create_timer(0.4).timeout
		return

	var direction: Vector2 = Vector2.ZERO

	# 3. Estado de Perseguição ativa (Correndo atrás da Maria)
	if target_player:
		direction = (target_player.global_position - global_position).normalized()
		velocity = direction * velocidade
		last_direction = direction
		update_run_animation(direction)
		move_and_slide()
	# 4. Estado de Patrulha no trilho (Andando pelo PathFollow2D)
	elif path_follow:
		var pos_anterior = path_follow.global_position
		path_follow.progress += velocidade_patrulha * delta
		direction = (path_follow.global_position - pos_anterior).normalized()
		if direction != Vector2.ZERO:
			last_direction = direction
			update_walk_animation(direction)
		else:
			update_idle_animation()
	# 5. Estado Parado
	else:
		velocity = Vector2.ZERO
		update_idle_animation()

func update_run_animation(dir: Vector2) -> void:
	if not animated_sprite:
		return
	if abs(dir.x) > abs(dir.y):
		animated_sprite.play("run_right" if dir.x > 0 else "run_left")
	else:
		animated_sprite.play("run_down" if dir.y > 0 else "run_up")

func update_walk_animation(dir: Vector2) -> void:
	if not animated_sprite:
		return
	if abs(dir.x) > abs(dir.y):
		animated_sprite.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		animated_sprite.play("walk_down" if dir.y > 0 else "walk_up")

func update_idle_animation() -> void:
	if not animated_sprite:
		return
	if abs(last_direction.x) > abs(last_direction.y):
		animated_sprite.play("idle_right" if last_direction.x > 0 else "idle_left")
	else:
		animated_sprite.play("idle_down" if last_direction.y > 0 else "idle_up")

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
			Audio.tocar("res://assets/sounds/uivo_bizarro.wav", true)
			# Ativa a HUD de 3 corações na tela quando começa o confronto final
			if modo_confronto_final:
				var vida_maria = body.vida_atual if "vida_atual" in body else 3
				get_tree().call_group("hud_combate", "iniciar_hud_combate", vida_maria, vida_atual)
			
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
		
	if body is Player and target_player != null and not capturou_player and not esta_despistado and not recuando and not empurrao:
		if not pode_atacar:
			return
			
		if modo_confronto_final:
			pode_atacar = false
			if body.has_method("take_damage"):
				body.take_damage(dano_no_player)
			
			await get_tree().create_timer(1.0).timeout
			pode_atacar = true
		else:
			# Comportamento do Bar / Fuga: morte instantânea
			capturou_player = true
			velocity = Vector2.ZERO
			if body.has_method("receber_dano_fatal"):
				Audio.tocar("res://assets/sounds/lobo_mordida.wav")
				body.receber_dano_fatal()

func take_damage(damage: int = 1) -> void:
	if empurrao or recuando:
		return 
	
	if not InventoryManager.has_item(item_necessario):
		if not DialogManager.is_open():
			DialogManager.start_talk([
				DialogInfoModel.new('player', 'Minha Nossa Senhora, eu não tenho nem um pau pra dar nele!')
			])
		return
	
	vida_atual -= damage
	piscar_dano()
	
	# Atualiza os corações do Lobisomem na HUD
	if modo_confronto_final:
		get_tree().call_group("hud_combate", "atualizar_vida_lobisomem", vida_atual)
	
	if vida_atual <= 0:
		derrotar()
		return
		
	if modo_confronto_final and target_player:
		empurrao = true
		var dir_empurrao = (global_position - target_player.global_position).normalized()
		empurrao_velocity = dir_empurrao * 260.0

func iniciar_recuo_tatico() -> void:
	if pontos_reposicionamento.is_empty():
		ponto_recuo_atual = global_position + (last_direction * -120.0)
		recuando = true
		return

	var candidatos: Array[Vector2] = []
	for path in pontos_reposicionamento:
		var marker = get_node_or_null(path)
		if marker is Node2D and marker.global_position.distance_to(global_position) > 60.0:
			candidatos.append(marker.global_position)

	if candidatos.size() > 0:
		ponto_recuo_atual = candidatos.pick_random()
		recuando = true

func piscar_dano() -> void:
	if animated_sprite:
		var interpolar = create_tween()
		interpolar.tween_property(animated_sprite, "modulate", Color.RED, 0.1)
		interpolar.tween_property(animated_sprite, "modulate", Color.WHITE, 0.1)

func derrotar() -> void:
	if modo_confronto_final:
		get_tree().call_group("hud_combate", "ocultar_hud")
		
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
