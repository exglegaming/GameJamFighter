extends CharacterBody2D

@export_category("Movement")
@export var patrol_speed: float = 100
@export var chase_speed: float = 200
@export var patrol_distance: float = 200

@export_category("Detection")
@export var detection_range: float = 150

enum State {
	PATROL,
	CHASE,
	IDLE
}

var current_state: State = State.PATROL
var patrol_direction: int = 1
var original_patrol_direction: int = 1
var player: CharacterBody2D = null

@onready var patrol_start_position: Vector2 = global_position
@onready var visuals: Node2D = $Visuals


func _ready() -> void:
	original_patrol_direction = patrol_direction

	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]


func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	check_player_detection()

	match current_state:
		State.PATROL:
			patrol_behavior()
		State.CHASE:
			chase_behavior()
		State.IDLE:
			idle_behavior()
	
	move_and_slide()
	update_visuals()


func check_player_detection() -> void:
	if not player:
		return

	var distance_to_player: float = global_position.distance_to(player.global_position)

	if distance_to_player <= detection_range:
		if current_state == State.PATROL:
			current_state = State.CHASE
			print("Player detected - chasing!")
	else:
		if current_state == State.CHASE:
			current_state = State.PATROL

			reset_patrol_direction()
			print("Player lost - returning to patrol")


func reset_patrol_direction() -> void:
	var distance_from_start: float = global_position.x - patrol_start_position.x

	if abs(distance_from_start) > patrol_distance * 0.5:
		patrol_direction = -sign(distance_from_start)
	else:
		patrol_direction = original_patrol_direction
	
	if patrol_direction == 0:
		patrol_direction = original_patrol_direction



func patrol_behavior() -> void:
	if patrol_direction == 0:
		patrol_direction = 1
	
	var distance_from_start = global_position.x - patrol_start_position.x
	if distance_from_start >= patrol_distance * 0.5:
		patrol_direction = -1
	elif distance_from_start <= -patrol_distance * 0.5:
		patrol_direction = 1
	
	velocity.x = patrol_direction * patrol_speed


func chase_behavior() -> void:
	if not player:
		current_state = State.PATROL
		return
	
	var direction_to_player = sign(player.global_position.x - global_position.x)

	if direction_to_player != 0:
		velocity.x = direction_to_player * chase_speed
	else:
		velocity.x = patrol_direction * chase_speed


func idle_behavior() -> void:
	velocity.x = 0
	await get_tree().create_timer(1.0).timeout
	if current_state == State.IDLE:
		current_state = State.PATROL


func update_visuals() -> void:
	if patrol_direction > 0:
		visuals.scale.x = 1
	else:
		visuals.scale.x = -1
