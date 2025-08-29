extends bossState
class_name chaseState

@onready var animation:AnimatedSprite2D = parent.get_node("Visuals/Sprites")

var direction:int

func Enter()->void :
	animation.play("run")
	MusicPlayer.on_battle()


func physicsUpdate(delta:float) ->void :
	var toPlayer = parent.global_position.direction_to(player.global_position).x 
	direction = sign(toPlayer)
	parent.velocity.x = direction * chaseSpeed
	
	
	handleGravity()
