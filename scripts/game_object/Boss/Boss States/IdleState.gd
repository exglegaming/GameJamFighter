extends bossState
<<<<<<< Updated upstream
class_name IdleState

=======
class_name IdleState 
>>>>>>> Stashed changes

var idleTime:float
@onready var animation = parent.get_node("Visuals/Sprites")

func Enter() -> void :
	idleTime = randf_range(0.5,2)
	parent.velocity.x = 0
	animation.play("Idle")

func physicsUpdate(delta:float) ->void:
	if idleTime > 0:
		idleTime -= delta
	else :
		Transitioned.emit(self,"WanderState")
		
		
	handleGravity()
