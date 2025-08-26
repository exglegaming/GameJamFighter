class_name HurtboxComponent extends Area2D

signal hit

@export var health_component: HealthComponent


func _ready() -> void:
    area_entered.connect(on_area_entered)
    

func on_area_entered(other_area: Area2D) -> void:
    if not other_area is HitboxComponent:
        return

    if health_component == null:
        return
    
    var hitbox_component: HitboxComponent = other_area
    health_component.damage(hitbox_component.damage)

    hit.emit()