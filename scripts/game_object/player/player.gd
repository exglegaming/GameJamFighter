extends CharacterBody2D

@export_category("Movement")
@export var speed: float = 300.0
@export var jump_velocity: float = -400.0


func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed(GameConstants.JUMP) and is_on_floor():
		velocity.y = jump_velocity

	var direction: float = Input.get_axis(GameConstants.MOVE_LEFT, GameConstants.MOVE_RIGHT)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
