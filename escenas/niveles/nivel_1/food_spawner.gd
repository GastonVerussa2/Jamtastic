extends Node2D

var food_scene = preload("res://escenas/collectables/comida.tscn")

@export var timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_spawn)
	pass # Replace with function body.


func _spawn():
	var lado_y = randi_range(0,1)
	var x = randi_range(-130,130)
	var y = randi_range(20,130)
	if lado_y == 0:
		y = -y
	
	var food = food_scene.instantiate()
	
	food.global_position.x = x
	food.global_position.y = y
	
	add_child(food)
	
