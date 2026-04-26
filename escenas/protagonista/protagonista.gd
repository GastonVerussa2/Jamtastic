extends CharacterBody2D

signal personaje_muerto

@export var area_prota: Area2D
@export var material_personaje_rojo: ShaderMaterial
@export var material_personaje_blanco: ShaderMaterial
@export var animacion: Sprite2D
@export var sonido_muerte: AudioStreamPlayer2D
@export var sonido_daño: AudioStreamPlayer2D
@export var sonido_dash: AudioStreamPlayer2D
@export var sonido_barra: AudioStreamPlayer2D

var _velocidad_default: float = 200.0
var _velocidad: float = 200.0
var _vida: int = 100
# Called when the node enters the scene tree for the first time.
var _tiempo_invulnerabilidad: float = 0.5
var _last_hit: float = 0.0

var _dash_time: float = 0.15
var _dash_remaining_time: float = 0
var _dash_multiplier: float = 5
var _muerto: bool = false

var _dash_cd: float = 2
var _dash_current_cd: float = 0

var _is_ready_to_attack: bool = true
var _enchanted_stone: EnchantedStone

func _ready() -> void:
	print(_vida)
	add_to_group("player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#Si ta muerto ya no hace nada
	if _muerto:
		return
	
	_checkear_ataque(delta)
	
	_checkear_dash(delta)
	
	# Si esta en pleno dash, ignora el resto
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
	
	if Input.is_action_just_pressed("barra"):
		sonido_barra.play()
	
	# se mueve
	move_and_slide()
	
	
	_decrementar_timers(delta)
	
	_checkear_colisiones(delta)

	if Input.is_action_just_pressed("barra"):
		sonido_barra.play()

func _checkear_ataque(delta: float):
	
	if _enchanted_stone == null:
		_enchanted_stone = get_tree().get_first_node_in_group("stone")
	
	if Input.is_action_pressed("attack") && !_enchanted_stone.is_attacking:
		_enchanted_stone.throw(self.global_position, get_global_mouse_position(), self)
		
		
	

func _checkear_colisiones(delta: float):
		#Checkea recepcion de daño, _last_hit es para saber si tas invunerable
	if area_prota.has_overlapping_bodies() && _last_hit == 0:
		var best_dmg = 0
		var bodies = area_prota.get_overlapping_bodies()
		for i in bodies.size():
			if bodies[i].damage > best_dmg:
				best_dmg = bodies[i].damage
		PlayerHpManager.change_health(-best_dmg)
		_last_hit = _tiempo_invulnerabilidad
		if PlayerHpManager.health == 0:
			animacion.material = material_personaje_rojo
			_muerto = true
			sonido_muerte.play()
			
			await get_tree().create_timer(1.5).timeout
			personaje_muerto.emit()
		else:
			sonido_daño.play()


func _checkear_dash(delta: float):	
	#	Checkea si esta apretando pa dashear y si tiene el dash listo
	if Input.is_action_pressed("dash") && _dash_remaining_time == 0 && _dash_current_cd == 0:
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
			
		# Si no dasheaste revierte los valores
		if velocity.x == 0 && velocity.y == 0:
			_velocidad = _velocidad_default
		else:
			_dash_remaining_time = _dash_time
			_dash_current_cd = _dash_cd
			sonido_dash.play()

func _decrementar_timers(delta: float):	
	#	Avanza los timers
	_dash_remaining_time -= delta
	if _dash_remaining_time < 0:
		_dash_remaining_time = 0 
		_velocidad = _velocidad_default
	
	#	Si se le recarga el dash, avisa
	if _dash_current_cd != 0 && _dash_current_cd <= delta:
		_dash_replenished()
		
	#	Avanza los timers
	_dash_current_cd -= delta
	if _dash_current_cd < 0:
		_dash_current_cd = 0 
	
	#	Avanza los timers
	_last_hit -= delta
	if _last_hit < 0:
		_last_hit = 0

func _dash_replenished():
	for i in 2:
		animacion.material = material_personaje_blanco
		await get_tree().create_timer(0.1).timeout
		animacion.material = null
		await get_tree().create_timer(0.1).timeout
	
	
