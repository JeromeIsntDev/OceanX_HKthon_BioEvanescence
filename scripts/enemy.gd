extends CharacterBody2D

@export var MAX_SPEED : float = 1.0
@export var ACCELERATION : float = 400.0
@export var FRICTION : float = 8.5
@export var player : CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player");

func _physics_process(delta: float) -> void:
	stateDuration += delta
	#LIGHT_RADIUS = minRadius + player.LUMINESCENCE * maxRadius
	var distance : float = sqrt((position.x - player.position.x) * (position.x - player.position.x) + (position.y - player.position.y) * (position.y - player.position.y))
	distance = clamp(maxRadius - distance, 0, maxRadius)
	player.danger_level = distance / (maxRadius * 2);
	var in_light := false
	if player:
		in_light = global_position.distance_to(player.global_position) <= LIGHT_RADIUS

func movement(delta: float, input : Vector2) -> void:
	var velocity_weight_x : float = 1.0 - exp( -(ACCELERATION if input.x else FRICTION) * delta)
	velocity.x = lerp(velocity.x, input.x * MAX_SPEED, velocity_weight_x);
	
	var velocity_weight_y : float = 1.0 - exp( -(ACCELERATION if input.y else FRICTION) * delta)
	velocity.y = lerp(velocity.y, input.y * MAX_SPEED, velocity_weight_y);
