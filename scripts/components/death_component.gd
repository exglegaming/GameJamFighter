extends Node2D

@export var health_component: HealthComponent


func  _ready() -> void:
    health_component.died.connect(on_died)


func on_died() -> void:
    if owner == null || not owner is Node2D:
        return
    
    var spawn_position = owner.global_position

    var entities: Node2D = get_tree().get_first_node_in_group("entities_layer")
    get_parent().remove_child(self)
    entities.add_child(self)

    global_position = spawn_position