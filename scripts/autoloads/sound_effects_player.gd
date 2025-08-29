extends AudioStreamPlayer

@export var sound_effects: Dictionary = {
	"sword_hit": preload("res://assets/audio/Sound effects/Sword hit.mp3"),
	"sword_attack": preload("res://assets/audio/Sound effects/Sword swoosh.mp3"),
	"jump": preload("res://assets/audio/Sound effects/Jump.mp3"),
	"jump_end": preload("res://assets/audio/Sound effects/JumpEnd.mp3"),
}

var default_volume: float = -10.0 
var current_effect: String = ""

func _ready() -> void:
	default_volume = volume_db


func play_sound(sound_name: String, volume_override: float = -1.0) -> void:
	pitch_scale = randf_range(0.8,1.2)
	if sound_name not in sound_effects:
		print("Sound effect not found: ", sound_name)
		return
	
	current_effect = sound_name
	
	if volume_override >= 0:
		volume_db = volume_override
	else:
		volume_db = default_volume
	
	stream = sound_effects[sound_name]
	play()


func stop_sound() -> void:
	stop()
	current_effect = ""


#region Convenience functions for common sound effects
func play_sword_hit() -> void:
	play_sound("sword_hit")


func play_sword_attack() -> void:
	play_sound("sword_attack")


func play_jump() -> void:
	play_sound("jump")

func play_jump_end() -> void:
	play_sound("jump_end")


func play_collect_item() -> void:
	pass
#endregion


func set_effects_volume(new_volume: float) -> void:
	default_volume = new_volume
	volume_db = new_volume
