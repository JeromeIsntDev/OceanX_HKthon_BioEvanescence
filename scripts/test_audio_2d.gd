extends Node2D

@export var AudioManager: audio_manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_sound(0, self);
