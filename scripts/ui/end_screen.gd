extends CanvasLayer

@onready var panel_container := %PanelContainer


func _ready() -> void:
	MusicPlayer.on_level_finsihed()
	panel_container.pivot_offset = panel_container.size / 2
	var tween := create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	%ContinueButton.pressed.connect(on_continue_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)


func set_defeat() -> void:
	%TitleLabel.text = "Defeat"
	%DescriptionLabel.text = "You lost!"


func on_continue_button_pressed() -> void:
	get_tree().paused = false
	MusicPlayer.on_game_start()
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
