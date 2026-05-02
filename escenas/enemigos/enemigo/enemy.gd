class_name Enemy
extends CharacterBody2D

@export var speed: float = 75.0
@export var sonido_spawn: AudioStreamPlayer2D
@export var material_personaje_rojo: ShaderMaterial
@export var sprite: Sprite2D

var damage: int = 10
var player: Node2D
var fake_target := Vector2(500,200)
var health: int
var main: MainScene
var experience_granted: int = 1

func _ready():
	main = get_tree().get_first_node_in_group("main")
	health = 8 + main.level
	speed = 40.0 + 5 * main.level
	player = get_tree().get_first_node_in_group("player")
	sonido_spawn.volume_linear = SoundManager.get_sound()
	sonido_spawn.play()


func _physics_process(_delta):
	
	var target_position: Vector2

	if player:
		target_position = player.global_position
	else:
		target_position = fake_target

	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()


func get_hit(damage: int):
	health -= damage
	sprite.material = material_personaje_rojo
	await get_tree().create_timer(0.1).timeout
	sprite.material = null
		
	if health <= 0:
		queue_free()
		_notificar_muerte()


func _notificar_muerte():
	if main:
		main.add_kill()
		main.add_xp(experience_granted) 
