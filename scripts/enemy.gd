extends CharacterBody2D

@export var MAX_SPEED : float = 150.0
@export var ACCELERATION : float = 200.0
@export var FRICTION : float = 8.5
@export var player : CharacterBody2D
@export var LIGHT_RADIUS : float = 200.0 

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player");

func _physics_process(delta: float) -> void:
	var direction : Vector2;
	if player:
		var dist := global_position.distance_to(player.global_position)
		if dist <= LIGHT_RADIUS:
			direction = (player.global_position - global_position).normalized()
	else:
		print("player missing")
	movement(delta, direction);
	move_and_slide();
#!_physic_process


func movement(delta: float, input : Vector2) -> void:
	var velocity_weight_x : float = 1.0 - exp( -(ACCELERATION if input.x else FRICTION) * delta)
	velocity.x = lerp(velocity.x, input.x * MAX_SPEED, velocity_weight_x);
	
	var velocity_weight_y : float = 1.0 - exp( -(ACCELERATION if input.y else FRICTION) * delta)
	velocity.y = lerp(velocity.y, input.y * MAX_SPEED, velocity_weight_y);
