extends Node2D

var food_scene = preload("res://escenas/collectables/comida.tscn")

@export var poligones: Array[Polygon2D]
@export var timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_spawn)
	pass # Replace with function body.


func _spawn():
	var i := randi_range(0, 3)
	var puntos = poligones[i].polygon
	var menor_x: float = 5000
	var mayor_x: float = -5000
	var menor_y: float = 5000
	var mayor_y: float = -5000
	var ant_x: float = 0
	var ant_y: float = 0
	for punto in puntos:
		if menor_x == null || punto.x < menor_x:
			menor_x = punto.x
		if mayor_x == null || punto.x > mayor_x:
			mayor_x = punto.x
		if menor_y == null || punto.y < menor_y:
			menor_y = punto.y
		if mayor_y == null || punto.y > mayor_y:
			mayor_y = punto.y
	print("el poligono ")
	print(i)
	print(menor_x)
	print(mayor_x)
	print(menor_y)
	print(mayor_y)
	
	if menor_x < 0:
		ant_x = menor_x
		menor_x += ant_x
		mayor_x += ant_x
	
	if menor_y < 0:
		ant_y = menor_y
		menor_y += ant_y
		mayor_y += ant_y
		
	var x := randf_range(menor_x, mayor_x)
	var y := randf_range(menor_y, mayor_y)
	
	if ant_x > 0:
		x -= ant_x
	
	if ant_y > 0:
		y -= ant_y
	
	var food = food_scene.instantiate()
	
	food.global_position.x = x
	food.global_position.y = y
	
	add_child(food)
