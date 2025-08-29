extends bossState
class_name WanderState


var wanderTime:float 
var direction:Vector2
@onready var animation = parent.get_node("Visuals/Sprites")

func Enter() ->void :
	wanderTime = randf_range(2,5)
	direction.x = -1 * direction.x
	while direction.x == 0 :
		direction.x = randi_range(-1,1)
	direction = direction.normalized()
	animation.play("walk")
	



func physicsUpdate(delta:float) ->void :
	
	parent.velocity.x = direction.x * WonderSpeed
	if parent.is_on_wall():
		direction.x *= -1
	
	
	if wanderTime > 0 :
		wanderTime -= delta
	else :
		Transitioned.emit(self,"IdleState")
		
	if parent.global_position.distance_to(player.global_position) <= detectionRange:
		Transitioned.emit(self,"chaseState")
		
	handleGravity()
