extends CanvasLayer

var options_scene: PackedScene = preload("res://scenes/ui/options_menu.tscn")

func _ready() -> void:
	MusicPlayer.on_menu_open()
	%PlayButton.pressed.connect(on_play_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)


func on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	MusicPlayer.on_game_start()


func on_options_pressed() -> void:
	var options_instance := options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_quit_pressed() -> void:
	get_tree().quit()

func on_options_closed(options_instance: Node) -> void:
	options_instance.queue_free()
