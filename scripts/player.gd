extends CharacterBody2D

const WALK_SPEED = 130.0
const RUN_SPEED = 230.0
var last_direction = Vector2.DOWN
var run = false
var speed = WALK_SPEED

@onready var animated_sprite = $AnimatedSprite2D
@onready var walking_sound: AudioStreamPlayer = $WalkingSound
const display_name: String = "Maria"

@onready var interaction_detector = $InteractionArea

func can_move():
	return !DialogManager.is_open() and !SceneManager.cutscene_running
	 

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_pressed("run"):
		speed = RUN_SPEED
		run = true
	else:
		speed = WALK_SPEED
		run = false
		
	# Funções update_animation e update_idle_animaton são para o player caminhando
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if can_move() && direction  != Vector2.ZERO:
		if(not walking_sound.playing):
			walking_sound.play()
		velocity = direction * speed
		last_direction = direction
		
		if run:
			update_run_animation(direction)
			
			walking_sound.pitch_scale = RUN_SPEED/WALK_SPEED
		else:
			walking_sound.pitch_scale = 1.0
			update_walk_animation(direction)
			
	else:
		walking_sound.stop()
		velocity = Vector2.ZERO
		update_idle_animation()

	move_and_slide()

func update_run_animation(dir: Vector2):
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

func update_walk_animation(dir: Vector2):
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
				
func update_idle_animation():	
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

# Funções de interação com os objetos
func interact():
	var overlapping_areas = interaction_detector.get_overlapping_areas()
	
	for area in overlapping_areas:
		if area is InteractionArea:
			area.interact()
			break;

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		interact()
