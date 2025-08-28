extends CharacterBody2D

class_name TheBoss

@export_category("mouvement")
@export var speed:int = 400
@export var jumpVelocity:int = -800

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group('player')


func _physics_process(delta: float) -> void:

	move_and_slide()
