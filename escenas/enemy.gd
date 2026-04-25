extends CharacterBody2D

@export var speed: float = 100.0
var player: Node2D
var fake_target := Vector2(500,200)
func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	var target_position: Vector2

	if player:
		target_position = player.global_position
	else:
		target_position = fake_target  # fallback

	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
