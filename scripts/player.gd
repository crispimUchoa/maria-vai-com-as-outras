extends CharacterBody2D

const WALK_SPEED = 130.0
const RUN_SPEED = 230.0
const display_name: String = "Maria"

var last_direction = Vector2.DOWN
var run = false
var speed = WALK_SPEED
var is_attacking: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var walking_sound: AudioStreamPlayer = $WalkingSound
@onready var interaction_detector = $InteractionArea
@onready var axe_hitbox_shape: CollisionShape2D = $AxeHitbox/CollisionShape2D

func _ready() -> void:
	# Garante que a colisão do ataque comece desativada
	if axe_hitbox_shape:
		axe_hitbox_shape.disabled = true
	
	# Conecta o sinal de fim da animação 
	if not animated_sprite.animation_finished.is_connected(_on_animated_sprite_2d_animation_finished):
		animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func can_move() -> bool:
	return !DialogManager.is_open() and !is_attacking

func _unhandled_input(event: InputEvent) -> void:
	# Ação de Ataque
	if event.is_action_pressed("attack") and not is_attacking:
		if InventoryManager.has_item("machado"):
			executar_ataque()
		else:
			print("Você precisa encontrar um machado primeiro!")
			
	if event.is_action_pressed("ui_accept"):
		interact()
		
func executar_ataque() -> void:
	is_attacking = true
	velocity = Vector2.ZERO
	
	if walking_sound.playing:
		walking_sound.stop()
	
	# ativa colisão hitbox no ataque
	if axe_hitbox_shape:
		axe_hitbox_shape.disabled = false
		atualizar_posicao_hitbox(last_direction)

	# Toca a animação correspondente
	tocar_animacao_ataque(last_direction)

func atualizar_posicao_hitbox(dir: Vector2) -> void:
	var offset := 24.0
	if abs(dir.x) > abs(dir.y):
		axe_hitbox_shape.position = Vector2(offset if dir.x > 0 else -offset, 0)
	else:
		axe_hitbox_shape.position = Vector2(0, offset if dir.y > 0 else -offset)

func tocar_animacao_ataque(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			animated_sprite.play("attack_right")
		else:
			animated_sprite.play("attack_left")
	else:
		if dir.y > 0:
			animated_sprite.play("attack_down")
		else:
			animated_sprite.play("attack_up")

func _physics_process(_delta: float) -> void:
	if is_attacking:
		return
	
	if Input.is_action_pressed("run"):
		speed = RUN_SPEED
		run = true
	else:
		speed = WALK_SPEED
		run = false
		
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if can_move() and direction != Vector2.ZERO:
		if not walking_sound.playing:
			walking_sound.play()
			
		velocity = direction * speed
		last_direction = direction
		
		if run:
			update_run_animation(direction)
			walking_sound.pitch_scale = RUN_SPEED / WALK_SPEED
		else:
			walking_sound.pitch_scale = 1.0
			update_walk_animation(direction)
	else:
		walking_sound.stop()
		velocity = Vector2.ZERO
		update_idle_animation()

	move_and_slide()

func update_run_animation(dir: Vector2) -> void:
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

func interact() -> void:
	var overlapping_areas = interaction_detector.get_overlapping_areas()
	for area in overlapping_areas:
		if area is InteractionArea or area.has_method("interact"):
			area.interact()
			break

func _on_animated_sprite_2d_animation_finished() -> void:
	if is_attacking:
		is_attacking = false
		if axe_hitbox_shape:
			axe_hitbox_shape.disabled = true
		update_idle_animation()
