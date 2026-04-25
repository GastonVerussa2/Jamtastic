extends Node2D

var enemy_scene = preload("res://escenas/enemigos/enemigo/enemy.tscn")

@export var spawn_interval: float = 1.5
@export var spawn_radius_min: float = 200
@export var spawn_radius_max: float = 400

var player: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	start_spawning()

func start_spawning():
	while true:
		spawn_enemy()
		await get_tree().create_timer(spawn_interval).timeout

func spawn_enemy():
	var enemy = enemy_scene.instantiate()

	var center: Vector2

	if player:
		center = player.global_position
	else:
		center = Vector2.ZERO  # fallback

	
	var angle = randf() * TAU
	var distance = randf_range(spawn_radius_min, spawn_radius_max)

	var offset = Vector2.RIGHT.rotated(angle) * distance

	enemy.global_position = center + offset

	add_child(enemy)
