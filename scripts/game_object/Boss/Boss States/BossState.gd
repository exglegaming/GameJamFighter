extends State
class_name bossState

@onready var parent:TheBoss = get_tree().get_first_node_in_group("TheBoss")
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group('player')
@onready var gravity:float = parent.gravity
@onready var chaseSpeed:int = parent.chaseSpeed
@onready var WonderSpeed:int = parent.WonderSpeed
@onready var jumpVelocity:int = parent.jumpVelocity
@onready var detectionRange:int = parent.detectionRange




func handleGravity():
	if !parent.is_on_floor() :
		if parent.velocity.y > 0:
			parent.velocity.y += gravity * 1.5
		else :
			parent.velocity.y += gravity
	else :
		parent.velocity.y = 0
