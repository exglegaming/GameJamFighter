extends Node

@onready var attack_name_text: RichTextLabel = get_node("AttackNameText")
@onready var ammo_container: HBoxContainer = get_node("AmmoContainer")
@onready var ammo_ui: Array = ammo_container.get_children()
func update_ui(player: Node2D) -> void:
	if !player:
		return
	match player.weapon:
		0:
			attack_name_text.text = "Attack: Melee"
			ammo_container.hide()
		1:
			update_ammo_ui(player.weapon_ammo[1])
			attack_name_text.text = "Attack: Throw"
			ammo_container.show()
		_:  
			pass
			
func update_ammo_ui(ammo_count:int) -> void:
	for i in ammo_ui.size():
		if ammo_count > i:
			ammo_ui[i].show()
		else:
			ammo_ui[i].hide()
		
