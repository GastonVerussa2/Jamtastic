class_name EnemySpawner

extends Node2D

var enemy_scene = preload("res://escenas/enemigos/enemigo/enemy.tscn")

@export var spawn_interval: float = 0.5
@export var spawn_radius_min: float = 200
@export var spawn_radius_max: float = 400

var player: Node2D
var spawning := false
var spawn_points: Array[Node]

func _ready():
	player = get_tree().get_first_node_in_group("player")
	spawn_points = get_tree().get_nodes_in_group("spawn_point")
	# Oculta los spawn
	for point in spawn_points:
		point.z_index = -25
	
	start_spawning()

func start_spawning():
	while spawning:
		spawn_enemy()
		await get_tree().create_timer(spawn_interval).timeout

# Funcion para spawnear en un spawn_point aleatorio
func spawn_enemy():
	
	var spawn: int = randi_range(0, spawn_points.size() - 1)
	
	if Input.is_action_pressed("disable_spawn"):
		spawning = false
	
	var enemy = enemy_scene.instantiate()
	
	enemy.global_position = spawn_points[spawn].global_position
	
	add_child(enemy)


# Funcion para spawnear al rededor del jugador
func spawn_enemy_random_place():
	
	if Input.is_action_pressed("disable_spawn"):
		spawning = false
	
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
	
	#spawn_sound.play()
