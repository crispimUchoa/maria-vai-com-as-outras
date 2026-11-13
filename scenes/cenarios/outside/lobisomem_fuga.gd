extends Node2D

@export var velocidade_fuga: float = 280.0
@export var trigger_area: Area2D

@onready var path_follow: PathFollow2D = get_parent() as PathFollow2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var fugindo: bool = false

func _ready() -> void:
	if not is_visible_in_tree():
		set_process(false)
		return
		
	if trigger_area and not trigger_area.body_entered.is_connected(_on_trigger_entered):
		trigger_area.body_entered.connect(_on_trigger_entered)

func _on_trigger_entered(body: Node2D) -> void:
	if not is_visible_in_tree() or fugindo:
		return
		
	if body is Player:
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
	
	# Quando chegar no fim do Path2D (progress_ratio >= 0.99), ele desaparece
	if path_follow.progress_ratio >= 0.99:
		fugindo = false
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
	# Registra a ação (isso também desativa o AGLobisomemFuga automaticamente)
	ProgressManager.add_action(ProgressManager.Action.VER_LOBI_FUGINDO)
	
	# Pequena pausa dramática após o lobisomem sumir antes dela falar
	await get_tree().create_timer(0.5).timeout
	
	DialogManager.start_talk([
		DialogInfoModel.new('player', 'Na página que eu achei na igreja mandava eu ter cuidado com o sétimo filho!'),
		DialogInfoModel.new('player', 'SÓ UMA FAMÍLIA TEM UM SÉTIMO FILHO NA MANGA!')
	])
