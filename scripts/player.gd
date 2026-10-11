extends CharacterBody2D

const SPEED = 128.0
var last_direction = Vector2.DOWN

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
		update_animation(direction)
	else:
		velocity = Vector2.ZERO
		update_idle_animation()

	move_and_slide()
	
func update_animation(dir: Vector2):
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
