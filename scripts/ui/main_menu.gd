extends CanvasLayer

var options_scene: PackedScene

func _ready() -> void:
    %PlayButton.pressed.connect(on_play_pressed)
    %OptionsButton.pressed.connect(on_options_pressed)
    %QuitButton.pressed.connect(on_quit_pressed)


func on_play_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/main.tscn")


func on_options_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/ui/options_menu.tscn")


func on_quit_pressed() -> void:
    get_tree().quit()
