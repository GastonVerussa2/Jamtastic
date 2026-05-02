class_name Projectile

extends CharacterBody2D

@export var area_pared: Area2D
@export var area_prota: Area2D

var _direction: Vector2
var _is_ready := false
var _speed: float
var _damage: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_pared.body_entered.connect(toca_pared)
	area_prota.body_entered.connect(toca_prota)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _is_ready:
		move_and_slide()

func throw(from: Vector2, to: Vector2, speed_granted: float, damage_granted: float):
	global_position = from
	look_at(to)
	_direction = (to - from).normalized()
	_speed = speed_granted
	velocity = _direction * _speed
	_damage = damage_granted
	_is_ready = true

func toca_pared(_body: Node2D):
	queue_free()

func toca_prota(body: Node2D):
	body.get_hit(_damage)
	queue_free()
