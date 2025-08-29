extends Node
<<<<<<< Updated upstream

=======
class_name StateMachine
@export var initialState:State
>>>>>>> Stashed changes


@export var initialState:State
var currentState : State
var States:Dictionary = {}

func _ready() -> void:
	for Child in get_children():
		if Child is State:
			States[Child.name.to_lower()] = Child
			Child.Transitioned.connect(stateTransitioned)
	if initialState:
		initialState.Enter()
		currentState = initialState
		

func _process(delta: float) -> void:
	if currentState:
		currentState.Update(delta)
func _physics_process(delta: float) -> void:
	if currentState:
		currentState.physicsUpdate(delta)
		


func stateTransitioned(state:State,new_state_name:StringName) ->void:
	if state != currentState:
		return
	var new_state:State = States.get(new_state_name.to_lower())
	
	if !new_state:
		return
	
	state.Exit()
	new_state.Enter()
	
	currentState = new_state
