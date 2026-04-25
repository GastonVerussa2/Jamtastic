extends CharacterBody2D

@export var area_prota: Area2D

var _velocidad_default: float = 200.0
var _velocidad: float = 200.0
var _vida: int = 100
# Called when the node enters the scene tree for the first time.
var _tiempo_invulnerabilidad: float = 0.5
var _last_hit: float = 0.0

var _dash_time: float = 0.15
var _dash_remaining_time: float = 0
var _dash_multiplier: float = 5

func _ready() -> void:
	print(_vida)
	add_to_group("player")
	area_prota.body_entered.connect(_colision_enemigo)
	area_prota.body_exited.connect(_colision_enemigo)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("dash") && _dash_remaining_time == 0:
		_dash_remaining_time = _dash_time
		_velocidad = _velocidad_default * _dash_multiplier
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
	
	if _dash_remaining_time == 0:
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
	
	_dash_remaining_time -= delta
	if _dash_remaining_time < 0:
		_dash_remaining_time = 0 
		_velocidad = _velocidad_default
	
	move_and_slide()
	
	_last_hit -= delta
	if _last_hit < 0:
		_last_hit = 0
	
	if area_prota.has_overlapping_bodies() && _last_hit == 0:
		var best_dmg = 0
		var bodies = area_prota.get_overlapping_bodies()
		for i in bodies.size():
			if bodies[i].damage > best_dmg:
				best_dmg = bodies[i].damage
		PlayerHpManager.change_health(-best_dmg)
		_last_hit = _tiempo_invulnerabilidad
	
	
func _colision_enemigo(body: Node2D) -> void:
	pass
	#if area_prota.has_overlapping_bodies()
	"""
	print("Auch recibi daño igual a ")
	_vida -= body.damage
	print(body.damage)
	print(_vida)
	PlayerHpManager.change_health(-body.damage)
	"""
	
