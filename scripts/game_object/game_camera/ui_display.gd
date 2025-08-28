extends Node

@onready var attack_name_text: RichTextLabel = get_node("AttackUi/AttackNameText")
@onready var ammo_container: HBoxContainer = get_node("AttackUi/AmmoContainer")
@onready var ammo_ui: Array = ammo_container.get_children()

@onready var hearts_container: HBoxContainer = get_node("HealthUi/HBoxContainer")
@onready var hearts_ui: Array = hearts_container.get_children()

func update_ui(player: Node2D) -> void:
	if !player:
		update_hearts_ui(0) #hides the last bit of hp when player gets queue free
		return
		
	# update hp ui
	update_hearts_ui(player.get_current_health())
	
	# update weapons ui
	match player.weapon:
		0:
			attack_name_text.text = "Attack: Melee"
			ammo_container.hide()
		1:
			update_ammo_ui(player.weapon_ammo[1])
			attack_name_text.text = "Attack: Throw"
			ammo_container.show()
		2:
			update_ammo_ui(player.weapon_ammo[2])
			attack_name_text.text = "Attack: Dash"
			ammo_container.show()
		_:  
			attack_name_text.text = "you should check ui_display.gd"
			ammo_container.hide()
			pass
			
func update_ammo_ui(ammo_count:int) -> void:
	for i in ammo_ui.size():
		if ammo_count > i:
			ammo_ui[i].show()
		else:
			ammo_ui[i].hide()
			
func update_hearts_ui(hp:int) -> void:
	for i in hearts_ui.size():
		if hp >= (i+1)*2:
			hearts_ui[i].show_full()
		elif hp >= (i+1)*2-1:
			hearts_ui[i].show_half()
		else:
			hearts_ui[i].show_none()
		
		
