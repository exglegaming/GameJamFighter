extends bossState
class_name attackState

@onready var Attacks = parent.Attacks
@onready var animation:AnimatedSprite2D = parent.get_node("Visuals/Sprites")



func Enter()->void:

	parent.velocity.x = 0
	await get_tree().create_timer(1).timeout
	Transitioned.emit(self,'WanderState')
