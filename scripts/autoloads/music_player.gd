extends AudioStreamPlayer

@export var tracks: Dictionary = {
    "menu": preload("res://assets/audio/Main menu.mp3"),
    "intro": preload("res://assets/audio/Intro story.mp3"),
    "battle": preload("res://assets/audio/Battle theme.ogg"),
    "outside_combat": preload("res://assets/audio/Outside combat.ogg"),
    "level_halfway": preload("res://assets/audio/Completed half level.mp3"),
    "level_finished": preload("res://assets/audio/Finished the level.mp3")
}

var current_track_name: String = ""
var should_loop: bool = true
var loop_with_delay: bool = true

@onready var loop_timer: Timer = $Timer


func _ready() -> void:
    finished.connect(on_finished)
    loop_timer.timeout.connect(on_timer_timeout)
    # play_track("menu")


func play_track(track_name: String, loop: bool = true, delay_loop: bool = true) -> void:
    if track_name == current_track_name and playing:
        return  # Already playing this track
    
    if track_name not in tracks:
        print("Track not found: ", track_name)
        return
    
    current_track_name = track_name
    should_loop = loop
    loop_with_delay = delay_loop
    
    stream = tracks[track_name]
    play()


func stop_music() -> void:
    stop()
    current_track_name = ""
    should_loop = false
    loop_timer.stop()


func on_finished() -> void:
    if should_loop:
        if loop_with_delay:
            loop_timer.start()
        else:
            play()


func on_timer_timeout() -> void:
    if should_loop:
        play()
    
#region chaning music track dependent on event
func on_game_start() -> void:
    play_track("intro")


func on_battle() -> void:
    play_track("battle", true, false)  # Loop without delay for intensity


func on_menu_open() -> void:
    play_track("menu")


func on_outside_combat() -> void:
    play_track("outside_combat")


func on_level_halfway() -> void:
    play_track("level_halfway")


func on_level_finsihed() -> void:
    play_track("level_finished")
#endregion

# Fade methods
func fade_out(duration: float = 1.0) -> void:
    var tween = create_tween()
    tween.tween_property(self, "volume_db", -80, duration)
    await tween.finished
    stop_music()

func fade_in_track(track_name: String, duration: float = 1.0) -> void:
    volume_db = -80
    play_track(track_name)
    var tween = create_tween()
    tween.tween_property(self, "volume_db", 0, duration)

func crossfade_to(track_name: String, duration: float = 1.0) -> void:
    var tween = create_tween()
    tween.tween_property(self, "volume_db", -80, duration * 0.5)
    await tween.finished
    play_track(track_name)
    tween = create_tween()
    tween.tween_property(self, "volume_db", 0, duration * 0.5)
