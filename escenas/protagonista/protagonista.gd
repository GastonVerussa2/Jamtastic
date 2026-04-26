class_name Protagonist

extends CharacterBody2D

signal personaje_muerto

@export var area_prota: Area2D
@export var material_personaje_rojo: ShaderMaterial
@export var material_personaje_blanco: ShaderMaterial
@export var animacion: AnimatedSprite2D
@export var sonido_muerte: AudioStreamPlayer2D
@export var sonido_daño: AudioStreamPlayer2D
@export var sonido_dash: AudioStreamPlayer2D
@export var sonido_barra: AudioStreamPlayer2D
@export var dash_cd_timer: Timer
@export var dash_duration_timer: Timer
@export var invunerability_timer: Timer


var _velocidad_default: float = 100.0
var _velocidad: float = 100.0
var _vida: int = 100

# Called when the node enters the scene tree for the first time.
var _tiempo_invulnerabilidad: float = 0.5

var _dash_time: float = 0.15
var _dash_multiplier: float = 5
var _muerto: bool = false

var _dash_cd: float = 2

var _enchanted_stone: EnchantedStone

func _ready() -> void:
	dash_cd_timer.wait_time = _dash_cd
	dash_duration_timer.wait_time = _dash_time
	invunerability_timer.wait_time = _tiempo_invulnerabilidad
	print(_vida)
	_enchanted_stone = get_tree().get_first_node_in_group("stone")
	dash_duration_timer.timeout.connect(_dash_finalizado)
	dash_cd_timer.timeout.connect(_dash_replenished)
	animacion.play("down_stone")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#Si ta muerto ya no hace nada
	if _muerto:
		return
	
	_checkear_ataque()
	
	_checkear_dash()
	
	_acomodar_animacion()
	
	# Si esta en pleno dash, ignora el resto
	if dash_duration_timer.time_left == 0:
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
	
	_checkear_colisiones()

	if Input.is_action_just_pressed("barra"):
		sonido_barra.play()

func _dash_finalizado():
	_velocidad = _velocidad_default
	dash_cd_timer.start()

func _checkear_ataque():
	
	if Input.is_action_pressed("attack") && !_enchanted_stone.is_attacking:
		_enchanted_stone.throw(self.global_position, get_global_mouse_position(), self)
	

func _acomodar_animacion():
	
	if not _enchanted_stone.is_attacking:
		if velocity.x < 0:
			animacion.play("left_stone")
		elif velocity.x > 0:
			animacion.play("right_stone")
		elif velocity.y < 0:
			animacion.play("up_stone")
		elif velocity.y > 0:
			animacion.play("down_stone")
	else:
		if velocity.x < 0:
			animacion.play("left_no_stone")
		elif velocity.x > 0:
			animacion.play("right_no_stone")
		elif velocity.y < 0:
			animacion.play("up_no_stone")
		elif velocity.y > 0:
			animacion.play("down_no_stone")

func _checkear_colisiones():
		#Checkea recepcion de daño, _last_hit es para saber si tas invunerable
	if area_prota.has_overlapping_bodies() && invunerability_timer.is_stopped():
		var best_dmg = 0
		var bodies = area_prota.get_overlapping_bodies()
		for i in bodies.size():
			if bodies[i].damage > best_dmg:
				best_dmg = bodies[i].damage
		PlayerHpManager.change_health(-best_dmg)
		invunerability_timer.start()
		if PlayerHpManager.health == 0:
			animacion.material = material_personaje_rojo
			_muerto = true
			sonido_muerte.play()
			
			await get_tree().create_timer(1.5).timeout
			personaje_muerto.emit()
		else:
			sonido_daño.play()

func _checkear_dash():	
	#	Checkea si esta apretando pa dashear y si tiene el dash listo
	if Input.is_action_pressed("dash") && dash_cd_timer.is_stopped() && dash_duration_timer.is_stopped():
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
			dash_duration_timer.start()
			sonido_dash.play()
			

func _dash_replenished():
	for i in 2:
		animacion.material = material_personaje_blanco
		await get_tree().create_timer(0.1).timeout
		animacion.material = null
		await get_tree().create_timer(0.1).timeout
	
	
