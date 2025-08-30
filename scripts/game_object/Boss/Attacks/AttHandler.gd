extends Node2D

@onready var parent:TheBoss
@onready var player:Player
@onready var stateMachine:StateMachine = $"../StateMachine"
@onready var attackStat:attackState = $"../StateMachine/attackState"
var attacks:Dictionary = {}

func _ready() -> void:
	if !parent:
		parent = get_tree().get_first_node_in_group("TheBoss")
	for Child in get_children():
		if Child is Attack:
			attacks[Child.name.to_lower()] = Child
	$"../AttTimer".timeout.connect(ItsTime)


func _physics_process(delta: float) -> void:
	if !parent:
		parent = get_tree().get_first_node_in_group("TheBoss")
	player = parent.player
	

func ItsTime() -> void:
	if parent.global_position.distance_to(player.global_position) < 40:
		var availible = check_attack_availible(parent.global_position.distance_to(player.global_position))
		if availible:
			var chosedAtt = randi_range(0,availible.size() - 1)
			availible[chosedAtt].Emit()
			stateMachine.currentState.Transitioned.emit(stateMachine.currentState,"attackState")
			
	$"../AttTimer".start(randf_range(3,8))

func check_attack_availible(range:float):
	var availible:Array
	for att in attacks:
		if attacks.get(att).range <= range:
			availible.append(attacks.get(att))
	return availible
