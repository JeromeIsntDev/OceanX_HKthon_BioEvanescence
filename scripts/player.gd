extends CharacterBody2D

@export var MAX_SPEED : float = 300.0
@export var ACCELERATION : float = 400.0
@export var FRICTION : float = 8.5
@export var GlowMask : Sprite2D
@export var SPOTLIGHT : ColorRect
@export var LUMINESCENCE : float = 0.1;


var original_mask : Color
var glow_changing : bool = false
var danger_level : float = 0.0

func _ready() -> void:
	original_mask = GlowMask.modulate
	SPOTLIGHT = get_tree().get_first_node_in_group("spotlight");


func _physics_process(delta: float) -> void:
	var input : Vector2 = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")).normalized();
	movement(delta, input);
		
	if input:
		change_glow(delta, Color(original_mask.r, original_mask.g, original_mask.b, 0.0), 5)
		if not glow_changing: change_flow_delay()
	else:
		if not glow_changing: change_glow(delta, original_mask, 5)

	move_and_slide()
	var uv : = Vector2(position.x/3200 + 0.5, position.y/3200 + 0.5)
	SPOTLIGHT.updateShader(uv)
	SPOTLIGHT.updateRange(LUMINESCENCE)
	SPOTLIGHT.updateDanger(danger_level)
#!_physic_process

func change_flow_delay() -> void:
	glow_changing = true
	await get_tree().create_timer(2.0).timeout
	glow_changing = false

func change_glow(delta: float, to : Color, fade_speed : float) -> void:
	GlowMask.self_modulate = GlowMask.self_modulate.lerp(to, delta * fade_speed);

func movement(delta: float, input : Vector2) -> void:
	var velocity_weight_x : float = 1.0 - exp( -(ACCELERATION if input.x else FRICTION) * delta)
	velocity.x = lerp(velocity.x, input.x * MAX_SPEED, velocity_weight_x);
	
	var velocity_weight_y : float = 1.0 - exp( -(ACCELERATION if input.y else FRICTION) * delta)
	velocity.y = lerp(velocity.y, input.y * MAX_SPEED, velocity_weight_y);
