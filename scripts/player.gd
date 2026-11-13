extends CharacterBody2D
class_name Player

@export var vida_max: int = 3
var vida_atual: int = 3
var invulneravel: bool = false

const WALK_SPEED = 130.0
const RUN_SPEED = 230.0
const display_name: String = "Maria"

var last_direction = Vector2.DOWN
var run = false
var speed = WALK_SPEED
var is_attacking: bool = false
var esta_morta: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var walking_sound: AudioStreamPlayer = $WalkingSound
@onready var swing_axe_sound: AudioStreamPlayer = $SwingAxeSound
@onready var interaction_detector = $InteractionArea

@onready var axe_area: Area2D = $AxeHitbox
@onready var axe_shape: CollisionShape2D = $AxeHitbox/CollisionAxe

var screen_size: Vector2

func _ready() -> void:
	vida_atual = vida_max
	animated_sprite.frame_changed.connect(_on_frame_changed)
	screen_size = get_viewport_rect().size
	
	if axe_shape:
		axe_shape.set_deferred("disabled", true)
	
	if not animated_sprite.animation_finished.is_connected(_on_animated_sprite_2d_animation_finished):
		animated_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func can_move() -> bool:
	return !DialogManager.is_open() and !is_attacking and !SceneManager.cutscene_running and !esta_morta

func _unhandled_input(event: InputEvent) -> void:
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
	swing_axe_sound.play()
	tocar_animacao_ataque(last_direction)

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
	if esta_morta or is_attacking:
		return
	
	if Input.is_action_pressed("run"):
		speed = RUN_SPEED
		run = true
	else:
		speed = WALK_SPEED
		run = false
		
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	update_interact_area_angle(direction)
	
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
	global_position = global_position.clamp(Vector2.ZERO, screen_size)

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

func update_interact_area_angle(direction: Vector2):
	if (direction):
		interaction_detector.rotation = direction.angle() - PI/2

func interact() -> void:
	var overlapping_areas = interaction_detector.get_overlapping_areas()
	for area in overlapping_areas:
		if area is InteractionArea or area.has_method("interact"):
			area.interact()
			break

func _on_animated_sprite_2d_animation_finished() -> void:
	if is_attacking:
		is_attacking = false
		if axe_shape:
			axe_shape.set_deferred("disabled", true)
		update_idle_animation()

func _on_frame_changed() -> void:
	if animated_sprite.animation.begins_with("attack"):
		match animated_sprite.animation:
			"attack_right":
				_frame_right()
			"attack_left":
				_frame_left()
			"attack_up":
				_frame_up()
			"attack_down":
				_frame_down()

func _frame_right() -> void:
	match animated_sprite.frame:
		0: axe_shape.set_deferred("disabled", true)
		1: 
			axe_shape.set_deferred("disabled", false)
			axe_shape.position = Vector2(31, -18)
		2: axe_shape.position = Vector2(25, -8)
		3: axe_shape.position = Vector2(20, -15)
		4: axe_shape.set_deferred("disabled", true)
		
func _frame_left() -> void:
	match animated_sprite.frame:
		0: axe_shape.set_deferred("disabled", true)
		1: 
			axe_shape.set_deferred("disabled", false)
			axe_shape.position = Vector2(-31, -18)
		2: axe_shape.position = Vector2(-25, -8)
		3: axe_shape.position = Vector2(-20, -15)
		4: axe_shape.set_deferred("disabled", true)

func _frame_up() -> void:
	match animated_sprite.frame:
		0: axe_shape.set_deferred("disabled", true)
		1: 
			axe_shape.set_deferred("disabled", false)
			axe_shape.position = Vector2(1, -26)
		2: axe_shape.position = Vector2(-12, -31)
		3: axe_shape.position = Vector2(0, -18)
		4: axe_shape.set_deferred("disabled", true)

func _frame_down() -> void:
	match animated_sprite.frame:
		0: axe_shape.set_deferred("disabled", true)
		1: 
			axe_shape.set_deferred("disabled", false)
			axe_shape.position = Vector2(12, -7)
		2: axe_shape.position = Vector2(3, -10)
		3: axe_shape.position = Vector2(11, -7)
		4: axe_shape.set_deferred("disabled", true)

func receber_dano_fatal() -> void:
	if esta_morta:
		return
		
	esta_morta = true
	vida_atual = 0
	get_tree().call_group("hud_combate", "atualizar_vida_maria", 0)
	velocity = Vector2.ZERO
	
	if walking_sound and walking_sound.playing:
		walking_sound.stop()
	
	# Força o play na animação "hurt"
	if animated_sprite and animated_sprite.sprite_frames.has_animation("hurt"):
		animated_sprite.play("hurt")
	else:
		print("[ERRO] Animação 'hurt' não encontrada no SpriteFrames da Maria!")

	# Espera os 1.5 segundos da animação de morte rodar ANTES de abrir diálogo ou game over
	await get_tree().create_timer(1.5).timeout
	game_over()

func take_damage(dano: int = 1) -> void:
	if esta_morta or invulneravel:
		return
		
	vida_atual -= dano
	get_tree().call_group("hud_combate", "atualizar_vida_maria", vida_atual)
	
	if vida_atual <= 0:
		receber_dano_fatal()
	else:
		# Empurrão leve e 1.2s de invulnerabilidade piscando
		invulneravel = true
		if animated_sprite:
			var tween = create_tween().set_loops(4)
			tween.tween_property(animated_sprite, "modulate:a", 0.3, 0.15)
			tween.tween_property(animated_sprite, "modulate:a", 1.0, 0.15)
		await get_tree().create_timer(1.2).timeout
		invulneravel = false

func game_over() -> void:
	Audio.parar()
	# Reinicia o jogo a partir do save ou recarrega a cena atual
	if GameManager.jogo_salvo:
		GameManager.carregar_jogo()
		get_tree().reload_current_scene()
	else:
		get_tree().reload_current_scene()
