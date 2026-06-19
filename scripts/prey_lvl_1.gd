extends CharacterBody2D

const SPEED = 300.0
const IDLE_DURATION = 2.0
const SWIM_DURATION = 1.0

enum State { IDLE, SWIM }
var state = State.IDLE
var stateDuration = 0.0
var swimDirection = Vector2.RIGHT

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
			
			if stateDuration >= SWIM_DURATION:
				change_state(State.IDLE)

	move_and_slide()

func change_state(new_state: State) -> void:
	state = new_state
	stateDuration = 0.0
