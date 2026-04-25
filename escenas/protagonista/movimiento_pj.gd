extends CharacterBody2D

@export var area_prota: Area2D

var _velocidad: float = 350.0
var _vida: int = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(_vida)
	add_to_group("player")
	area_prota.body_entered.connect(_colision_enemigo)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_pressed("up"):
		velocity.y = - _velocidad
	elif Input.is_action_pressed("down"):
		velocity.y = _velocidad
	else:
		velocity.y = 0
	
	if Input.is_action_pressed("left"):
		velocity.x = - _velocidad
	elif Input.is_action_pressed("right"):
		velocity.x = _velocidad
	else:
		velocity.x = 0
	
	move_and_slide()
	
func _colision_enemigo(body: Node2D) -> void:
	print("Auch recibi daño igual a ")
	_vida -= body.daño
	print(body.daño)
	print(_vida)
	PlayerHpManager.change_health(-body.daño)
	
