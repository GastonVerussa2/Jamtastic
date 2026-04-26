class_name EnchantedStone

extends CharacterBody2D

signal hit_enemies(damage: int, enemies: Array[Node2D])

# areas
@export var area_vuelta: Area2D
@export var area_golpe: Area2D

#Sonidos
@export var hit_sound_1: AudioStreamPlayer2D
@export var hit_sound_2: AudioStreamPlayer2D
@export var solid_hit_sound: AudioStreamPlayer2D
@export var throw_sound: AudioStreamPlayer2D
@export var returning_sound: AudioStreamPlayer2D

#datos
@export var speed: float = 250.0
@export var return_acceleration: float = 300.0
@export var return_speed: float = 0.0
@export var max_distance: float = 150.0

var direction: Vector2
var start_position: Vector2
var player: Node2D
var returning := false
var is_attacking := false
var damage = 1
var last_sound = 1

func _ready() -> void:
	area_golpe.body_entered.connect(hit_enemy)
	_disappear()

func _physics_process(delta):
	if is_attacking:
		
			# Tambien debe hacerle daño al enemigo
		if area_vuelta.has_overlapping_bodies():
			if not returning:
				solid_hit_sound.play()
			go_back()
	
		if not returning:
			velocity = direction * speed
			rotation += 10 * delta
			
			# cuando se aleja mucho → vuelve
			if global_position.distance_to(start_position) > max_distance:
				go_back()
		else:
			if player:
				return_speed += return_acceleration * delta
				var dir_to_player = (player.global_position - global_position).normalized()
				velocity = dir_to_player * return_speed

				# cuando llega al player → desaparece
				if global_position.distance_to(player.global_position) < 20:
					return_speed = 0
					_disappear()
		move_and_slide()

func hit_enemy(body: Node2D):
	# Random boolean
	if randi_range(0, 1):
		hit_sound_1.play()
	else:
		hit_sound_2.play()
	body.get_hit(damage)
	go_back()
	

func go_back():
	if not returning:
		returning = true
		returning_sound.play()

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
	throw_sound.play(0.4)
