extends CharacterBody2D

class_name TheBoss
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group('player')

@export_category("mouvement")
@export var WonderSpeed:int = 100
@export var chaseSpeed:int = 200
@export var jumpVelocity:int = -500
@export var gravity:float = 5

<<<<<<< Updated upstream
func _physics_process(delta: float) -> void:
=======
@export var detectionRange:int = 150

@onready var visuals: Node2D = $Visuals
@onready var sprites: AnimatedSprite2D = $Visuals/Sprites
@onready var state_machine: StateMachine = $StateMachine
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group('player')


var Attacks:Dictionary = {}
>>>>>>> Stashed changes

func _ready() -> void:
	for Child in $Attacks.get_children():
		if Child is Attack:
			Attacks[Child.name.to_lower()] = Child

func _physics_process(delta: float) -> void:
	
	move_and_slide()
	updateVisuals()



func updateVisuals():
	var direction = velocity.x / abs(velocity.x)
	if velocity.x :
		visuals.scale.x = direction
