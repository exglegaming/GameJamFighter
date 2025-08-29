extends AudioStreamPlayer

@export var tracks: Dictionary = {
	"menu": preload("res://assets/audio/Main menu.mp3"),
	"intro": preload("res://assets/audio/Intro story.mp3"),
	"battle": preload("res://assets/audio/Battle theme.ogg"),
	"outside_combat": preload("res://assets/audio/Outside combat.ogg"),
	"level_halfway": preload("res://assets/audio/Completed half level.mp3"),
	"level_finished": preload("res://assets/audio/Finished the level.mp3"),
	"ambient": preload("res://assets/audio/Ambient.ogg")
}

var current_track_name: String = ""
var should_loop: bool = true
var loop_with_delay: bool = true
var default_volume: float = 0.0

@onready var loop_timer: Timer = $Timer


func _ready() -> void:
	default_volume = volume_db
	finished.connect(on_finished)
	loop_timer.timeout.connect(on_timer_timeout)


func play_track(track_name: String, loop: bool = true, delay_loop: bool = true) -> void:
	if track_name == current_track_name and playing:
		return  # Already playing this track
	
	if track_name not in tracks:
		print("Track not found: ", track_name)
		return
	
	current_track_name = track_name
	should_loop = loop
	loop_with_delay = delay_loop
	
	volume_db = default_volume
	stream = tracks[track_name]
	# Ensure outside_combat loops
	if track_name == "outside_combat":
		if stream is AudioStreamOggVorbis:
			stream.loop = true
		elif stream is AudioStreamMP3:
			stream.loop = true
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
	crossfade_to("ambient")


func on_battle() -> void:
	play_track("battle")
	should_loop = true
	loop_with_delay = false


func on_menu_open() -> void:
	crossfade_to("menu")


func on_outside_combat() -> void:
	crossfade_to("outside_combat", 2, true, false)


func on_level_halfway() -> void:
	crossfade_to("level_halfway")


func on_level_finished() -> void:
	crossfade_to("level_finished")
#endregion


# Fade methods
func fade_in_track(track_name: String, duration: float = 1.0) -> void:
	volume_db = -80  # Start from silence
	play_track(track_name)
	
	var tween = create_tween()
	tween.tween_property(self, "volume_db", default_volume, duration)


func crossfade_to(track_name: String, duration: float = 1.0, loop: bool = true, delay_loop: bool = true) -> void:
	if not playing:
		fade_in_track(track_name, duration)
		return
	
	# Fade out current track
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80, duration * 0.5)
	await tween.finished
	
	# Start new track and fade in
	play_track(track_name, loop, delay_loop)
	tween = create_tween()
	tween.tween_property(self, "volume_db", default_volume, duration * 0.5)
