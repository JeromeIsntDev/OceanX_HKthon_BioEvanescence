extends AudioStreamPlayer2D

@export var Sounds : Array[sound_effect]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_sound(index: int) -> void:
	if Sounds[index]: push_error("MISSING AUDIO");
