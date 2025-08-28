extends CharacterBody2D

class_name TheBoss
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group('player')

@export_category("mouvement")
@export var speed:int = 400
@export var jumpVelocity:int = -800

func _physics_process(delta: float) -> void:

	move_and_slide()
