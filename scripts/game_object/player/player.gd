extends CharacterBody2D

@export_category("Movement")
@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var acceleration: float = 1500
@export var friction: float = 1200

var number_colliding_bodies := 0

@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var visuals: Node2D = $Visuals


func _ready() -> void:
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)

	anim_sprite.flip_h = false


func _process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed(GameConstants.JUMP) and is_on_floor():
		velocity.y = jump_velocity

	var direction: float = get_direction()
	if direction != 0:
		velocity.x = move_toward(velocity.x , direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()
	update_animations(direction)


func get_direction() -> float:
	return Input.get_axis(GameConstants.MOVE_LEFT, GameConstants.MOVE_RIGHT)


func update_animations(direction: float) -> void:
	if direction > 0:
		visuals.scale.x = 1
		# anim_sprite.flip_h = false
	elif direction < 0:
		visuals.scale.x = -1
		# anim_sprite.flip_h = true

	if abs(velocity.x) > 5:
		anim_sprite.play("walk")
	else:
		anim_sprite.play("idle")


func check_deal_damage() -> void:
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()


func on_body_entered(other_body: Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D) -> void:
	number_colliding_bodies -= 1
