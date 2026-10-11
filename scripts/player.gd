extends CharacterBody2D


const SPEED = 128.0

@onready var interaction_detector = $InteractionArea

func _physics_process(delta: float) -> void:
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func interact():
	var overlapping_areas = interaction_detector.get_overlapping_areas()
	
	for area in overlapping_areas:
		if area is InteractionArea:
			area.interact()
			break;

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		interact()
