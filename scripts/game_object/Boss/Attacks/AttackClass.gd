extends Area2D

class_name Attack

@export var damage:float
@export var StartupTime:float = 0
@export var ActiveTime:float = 0
@export var range:float
@export var waitTime:float

func _ready() -> void:
	area_entered.connect(BodyEntred)


func Attack():
	await get_tree().create_timer(StartupTime).timeout
	monitoring = true
	await get_tree().create_timer(ActiveTime).timeout
	monitoring = false
	pass


func BodyEntred(body)->void:
	
	pass
