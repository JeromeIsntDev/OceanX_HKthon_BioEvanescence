extends Node2D

@export var prey_scene : PackedScene
@export var max_prey : int = 5
@export var respawn_delay : float = 4.0

## How far from the player prey can spawn (min/max ring)
@export var spawn_min_radius : float = 300.0
@export var spawn_max_radius : float = 600.0

var player : Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	for i in max_prey:
		spawn_prey()

func spawn_prey() -> void:
	if not prey_scene:
		push_error("PreyManager: prey_scene is not set!")
		return

	var prey = prey_scene.instantiate()

	# Spawn in a ring around the player so it's always nearby but off-screen
	var angle := randf() * TAU
	var dist  := randf_range(spawn_min_radius, spawn_max_radius)
	var origin := player.global_position if player else Vector2.ZERO
	prey.position = origin + Vector2(cos(angle), sin(angle)) * dist

	prey.eaten.connect(_on_prey_eaten)
	add_child(prey)

func _on_prey_eaten() -> void:
	print("prey eaten, respawning in ", respawn_delay, "s")
	await get_tree().create_timer(respawn_delay).timeout
	spawn_prey()
	print("prey respawned")
	
