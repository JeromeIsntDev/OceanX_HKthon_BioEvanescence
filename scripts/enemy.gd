extends CharacterBody2D

@export var MAX_SPEED : float = 150.0
@export var ACCELERATION : float = 100.0
@export var FRICTION : float = 8.5
@export var player : CharacterBody2D

## Radius of the anglerfish's light bubble — enemy chases only within this range.
@export var LIGHT_RADIUS : float = 170.0

## Wander tuning
@export var WANDER_SPEED : float = 100.0
@export var IDLE_DURATION : float = 2.0
@export var SWIM_DURATION : float = 1.0

enum State { IDLE, SWIM, CHASE }
var state := State.IDLE
var stateDuration : float = 0.0
var swimDirection := Vector2.RIGHT
var maxRadius : float = 200
var minRadius : float = 10

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	stateDuration += delta
	LIGHT_RADIUS = minRadius + player.LUMINESCENCE * 10 * maxRadius

	var in_light := false
	if player:
		in_light = global_position.distance_to(player.global_position) <= LIGHT_RADIUS

	# Switch into or out of CHASE
	if in_light and state != State.CHASE:
		change_state(State.CHASE)
	elif not in_light and state == State.CHASE:
		change_state(State.IDLE)

	match state:
		State.IDLE:
			# Gentle bobbing, same as prey
			var idle_input := Vector2(0.0, sin(stateDuration * 2.0) * 0.1)
			movement(delta, idle_input)

			if stateDuration >= IDLE_DURATION:
				swimDirection = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
				change_state(State.SWIM)

		State.SWIM:
			movement(delta, swimDirection)

			if stateDuration >= SWIM_DURATION:
				change_state(State.IDLE)

		State.CHASE:
			var direction := (player.global_position - global_position).normalized()
			movement(delta, direction)

	move_and_slide()

func change_state(new_state: State) -> void:
	state = new_state
	stateDuration = 0.0

func movement(delta: float, input: Vector2) -> void:
	# Use WANDER_SPEED for idle/swim, MAX_SPEED for chase
	var target_speed := MAX_SPEED if state == State.CHASE else WANDER_SPEED

	var velocity_weight_x := 1.0 - exp(-(ACCELERATION if input.x else FRICTION) * delta)
	velocity.x = lerp(velocity.x, input.x * target_speed, velocity_weight_x)

	var velocity_weight_y := 1.0 - exp(-(ACCELERATION if input.y else FRICTION) * delta)
	velocity.y = lerp(velocity.y, input.y * target_speed, velocity_weight_y)
