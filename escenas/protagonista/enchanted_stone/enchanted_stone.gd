class_name EnchantedStone

extends CharacterBody2D

@export var area_vuelta: Area2D
@export var area_golpe: Area2D
@export var speed: float = 500.0
@export var return_speed: float = 700.0
@export var max_distance: float = 300.0

var direction: Vector2
var start_position: Vector2
var player: Node2D
var returning := false
var is_attacking := false

func _ready() -> void:
	add_to_group("stone")
	_disappear()
	print("me meti al grupitooo")
	print(get_groups())

func _physics_process(delta):
	if is_attacking:
		#if area_piedra.has_overlapping_bodies()
		if not returning:
			velocity = direction * speed
			rotation += 10 * delta
			
			# cuando se aleja mucho → vuelve
			if global_position.distance_to(start_position) > max_distance:
				returning = true
		else:
			if player:
				var dir_to_player = (player.global_position - global_position).normalized()
				velocity = dir_to_player * return_speed

				# cuando llega al player → desaparece
				if global_position.distance_to(player.global_position) < 20:
					_disappear()
		print(direction)
		move_and_slide()
	
	print(returning)
	
func _disappear():
	is_attacking = false
	global_position.x = 15000
	global_position.y = 15000
	
func throw(starting_position: Vector2, objective_position: Vector2, player_node: Node2D):
	is_attacking = true
	returning = false
	player = player_node
	global_position = starting_position
	start_position = starting_position
	direction = (objective_position - starting_position).normalized()
