extends Node2D

var food_scene = preload("res://escenas/collectables/comida.tscn")

@export var timer: Timer
@export var mesa: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_spawn)
	pass # Replace with function body.


func _spawn():
	var lado_y = randi_range(0,1)
	var x = randi_range(-140,140)
	var y = randi_range(20,140)
	if lado_y == 0:
		y = -y
	
	var food = food_scene.instantiate()
	
	add_child(food)
	
	food.global_position.x = mesa.global_position.x + x
	food.global_position.y = mesa.global_position.y + y
