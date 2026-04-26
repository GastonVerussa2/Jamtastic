class_name Enemy
extends CharacterBody2D

@export var speed: float = 100.0
@export var sonido_spawn: AudioStreamPlayer2D

var damage: int = 5
var player: Node2D
var fake_target := Vector2(500,200)
var health: int = 1

func _ready():
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")
	sonido_spawn.play()

func _physics_process(delta):
	var target_position: Vector2

	if player:
		target_position = player.global_position
	else:
		target_position = fake_target  # fallback

	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func get_hit(damage: int):
	health -= damage
	
	if health <= 0:
		_notificar_muerte()
		queue_free()

func _notificar_muerte():
	var main = get_tree().get_first_node_in_group("main")
	if main:
		main.add_kill()
