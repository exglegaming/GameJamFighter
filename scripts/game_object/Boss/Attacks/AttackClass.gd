extends Area2D

class_name Attack

signal attack
@export var damage:float
@export var StartupTime:float = 0
@export var ActiveTime:float = 0
@export var range:float
@export var waitTime:float
@export var stunnTime:float = 0.5



func _ready() -> void:
	area_entered.connect(BodyEntred)


func Attack():
	await get_tree().create_timer(StartupTime).timeout
	get_parent().sprites.play(self.name.to_lower())
	monitoring = true
	await get_tree().create_timer(ActiveTime).timeout
	monitoring = false

func Emit() -> void :
	attack.emit(self.name.to_lower())


func BodyEntred(body:Node2D)->void:

	if body.get_parent().is_in_group("player"):
		var player:Player = body.get_parent()
		if player:
			player.number_colliding_bodies = 1
			player.stunned = true
			player.check_deal_damage()
			player.number_colliding_bodies = 0
			await get_tree().create_timer(StartupTime + ActiveTime).timeout
			player.stunned = false
