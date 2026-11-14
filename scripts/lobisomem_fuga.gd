extends Node2D

@export var velocidade_fuga: float = 280.0

@onready var path_follow: PathFollow2D = get_parent() as PathFollow2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var fugindo: bool = false
var evento_concluido: bool = false

func _ready() -> void:
	set_process(false)
	
	if path_follow:
		path_follow.loop = false
		path_follow.rotates = false
		path_follow.progress_ratio = 0.0
		
		var path_2d = path_follow.get_parent() as Path2D
		if path_2d and (not path_2d.curve or path_2d.curve.get_baked_length() < 10.0):
			push_warning("[LobisomemFuga] O Path2D não tem linha desenhada! Adicione pontos nele no editor 2D.")
	
	# Conecta automaticamente a todas as Area2D / InteractionArea dentro do ActGroup
	var grupo_pai = _encontrar_act_group()
	if grupo_pai:
		for area in grupo_pai.find_children("*", "Area2D", true, false):
			if not area.body_entered.is_connected(_on_area_body_entered):
				area.body_entered.connect(_on_area_body_entered)
			if not area.area_entered.is_connected(_on_area_area_entered):
				area.area_entered.connect(_on_area_area_entered)

func _encontrar_act_group() -> Node:
	var atual: Node = get_parent()
	while atual:
		if atual is ActGroup:
			return atual
		atual = atual.get_parent()
	return get_parent()

func _on_area_body_entered(body: Node2D) -> void:
	if body is Player:
		iniciar_fuga()

func _on_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		iniciar_fuga()

func interact() -> void:
	iniciar_fuga()

func iniciar_fuga() -> void:
	if not is_visible_in_tree() or fugindo or evento_concluido:
		return
	if ProgressManager.has_action(ProgressManager.Action.VER_LOBI_FUGINDO):
		return
		
	fugindo = true
	set_process(true)

func _process(delta: float) -> void:
	if not fugindo or not path_follow:
		return
		
	var pos_anterior = path_follow.global_position
	path_follow.progress += velocidade_fuga * delta
	var dir = (path_follow.global_position - pos_anterior).normalized()
	
	_atualizar_animacao(dir)
	
	if path_follow.progress_ratio >= 0.99:
		fugindo = false
		evento_concluido = true
		set_process(false)
		visible = false
		_concluir_evento_fuga()

func _atualizar_animacao(dir: Vector2) -> void:
	if not animated_sprite or dir == Vector2.ZERO:
		return
	if abs(dir.x) > abs(dir.y):
		animated_sprite.play("run_right" if dir.x > 0 else "run_left")
	else:
		animated_sprite.play("run_down" if dir.y > 0 else "run_up")

func _concluir_evento_fuga() -> void:
	await get_tree().create_timer(0.5).timeout
	
	DialogManager.start_talk([
		DialogInfoModel.new('player', 'Na página que eu achei na igreja mandava eu ter cuidado com o sétimo filho!'),
		DialogInfoModel.new('player', 'SÓ UMA FAMÍLIA TEM UM SÉTIMO FILHO NA MANGA!')
	])
	
	ProgressManager.do_action(ProgressManager.Action.VER_LOBI_FUGINDO)
