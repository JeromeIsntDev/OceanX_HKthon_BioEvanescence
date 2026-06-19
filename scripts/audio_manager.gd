class_name audio_manager
extends Node2D

@export var Sounds : Array[sound_effect]

func play_sound(index: int, obj: Node2D) -> void:
	if not Sounds[index]: push_error("MISSING AUDIO");
	var new_sound : sound_effect = Sounds[index];
	spawn_stream_player(new_sound, obj);

func spawn_stream_player(sound : sound_effect, obj: Node2D):
	var stream_player := AudioStreamPlayer2D.new();
	stream_player.stream = sound.stream;
	stream_player.volume_db = sound.volume;
	stream_player.pitch_scale = sound.pitch
	stream_player.max_distance = sound.distance
	obj.add_child(stream_player)
	stream_player.finished.connect(stream_player.queue_free)
	stream_player.play()
