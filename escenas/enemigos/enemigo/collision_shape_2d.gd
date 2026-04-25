extends CharacterBody2D

@export var speed: float = 500.0
@export var return_speed: float = 700.0
@export var max_distance: float = 300.0

var direction: Vector2
var start_position: Vector2
var player: Node2D
var returning := false

func _ready():
	start_position = global_position
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if not returning:
		velocity = direction * speed

		# cuando se aleja mucho → vuelve
		if global_position.distance_to(start_position) > max_distance:
			returning = true
	else:
		if player:
			var dir_to_player = (player.global_position - global_position).normalized()
			velocity = dir_to_player * return_speed

			# cuando llega al player → desaparece
			if global_position.distance_to(player.global_position) < 20:
				queue_free()

	move_and_slide()
