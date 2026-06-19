extends Node2D

signal eaten

const SPEED = 150.0
const IDLE_DURATION = 2.0
const SWIM_DURATION = 1.0

enum State { IDLE, SWIM }
var state = State.IDLE
var stateDuration = 0.0
var swimDirection = Vector2.RIGHT
var velocity := Vector2.ZERO

@onready var sprite = $Sprite2D
@onready var area = $area

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	stateDuration += delta

	match state:
		State.IDLE:
			velocity.x = 0
			velocity.y = sin(stateDuration * 2.0) * 30.0

			if stateDuration >= IDLE_DURATION:
				swimDirection = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
				change_state(State.SWIM)

		State.SWIM:
			velocity = swimDirection * SPEED
			sprite.flip_v = swimDirection.x < 0

			if stateDuration >= SWIM_DURATION:
				change_state(State.IDLE)

	# Move the root Node2D directly since Area2D has no move_and_slide
	position += velocity * delta

func change_state(new_state: State) -> void:
	state = new_state
	stateDuration = 0.0

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		eaten.emit()
		queue_free()
