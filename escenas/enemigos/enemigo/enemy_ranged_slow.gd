extends CharacterBody2D

var projectile_scene = preload("res://escenas/enemigos/projectile_slow.tscn")

@export var speed: float = 75.0
@export var sonido_spawn: AudioStreamPlayer2D
@export var material_personaje_rojo: ShaderMaterial
@export var sprite: Sprite2D
@export var change_direction_timer: Timer
@export var attack_timer: Timer
@export var starting_timer: Timer

var damage: int = 10
var player: Node2D
var fake_target := Vector2(500,200)
var health: int
var main: MainScene
var experience_granted: int = 1
var direction: Vector2
var projectile_speed: float = 35
var attack_speed: float = 2


func _ready():
	main = get_tree().get_first_node_in_group("main")
	health = 4 + main.level
	speed = 35.0 + 2.5 * main.level
	player = get_tree().get_first_node_in_group("player")
	sonido_spawn.volume_linear = SoundManager.get_sound()
	sonido_spawn.play()
	direction = Vector2.RIGHT.rotated(randf_range(0.0, 360.0))
	change_direction_timer.timeout.connect(change_direction)
	attack_timer.wait_time = attack_speed
	attack_timer.timeout.connect(attack)
	await starting_timer.timeout
	attack_timer.start()


func _physics_process(_delta):

	velocity = direction * speed
	move_and_slide()

func change_direction():
	direction = Vector2.RIGHT.rotated(randf_range(0.0, 360.0))

func get_hit(damage_taken: int):
	health -= damage_taken
	sprite.material = material_personaje_rojo
	await get_tree().create_timer(0.1).timeout
	sprite.material = null
		
	if health <= 0:
		queue_free()
		_notificar_muerte()
		
func attack():
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	var projectile = projectile_scene.instantiate()
	projectile.throw(self.global_position, player.global_position, projectile_speed, damage)
	main.add_child(projectile)

func _notificar_muerte():
	if main:
		main.add_kill()
		main.add_xp(experience_granted) 
