class_name MainScene

extends Node2D

signal level_up_pj

@export var niveles: Array[PackedScene]
@export var kills_label: Label
@export var xp_sound: AudioStreamPlayer2D
@export var container: HBoxContainer
@export var pause_menu: PauseMenu

const UpgradeMenu = preload("res://escenas/UpgradeMenu/upgrade_menu.tscn") 

const ICON_SPEED = preload("res://sprites/SPEED_UP.png")
const ICON_DAMAGE = preload("res://sprites/dano_up.png")
const ICON_HEALTH = preload("res://sprites/Corazon_hp_up.png")

var _nivel_actual: int = 1
var _nivel_instanciado: Node

var hp: HpControl

# -------------------
# SCORE
# -------------------
var _kills: int = 0

# -------------------
# XP SYSTEM
# -------------------
var xp: int = 0
var level: int = 1
var xp_to_next: int = 5
var _leveling_up := false


func _ready() -> void:
	_crear_nivel(_nivel_actual)
	update_kills_label()
	xp_sound.volume_linear = SoundManager.get_sound()


func _process(_delta: float):
	if Input.is_action_just_pressed("pausasa"):
		pause_menu.pausar()
		get_tree().paused = true


func _crear_nivel(numero_nivel: int):
	if _nivel_actual == 1:
		container.visible = false
	else:
		container.visible = true
	
	_nivel_instanciado = niveles[numero_nivel - 1].instantiate()
	add_child(_nivel_instanciado)
	
	var hijos: Array = _nivel_instanciado.get_children()
	
	for i in hijos.size():
		if hijos[i].is_in_group("player"):
			hijos[i].personaje_muerto.connect(_reiniciar_nivel)
			break
			

func _eliminar_nivel():
	_nivel_instanciado.queue_free()


func _reiniciar_nivel():
	_eliminar_nivel()
	_kills = 0
	update_kills_label()
	_crear_nivel.call_deferred(_nivel_actual)
	PlayerHpManager.reset_life()

func avanzar_nivel():
	_nivel_actual += 1
	_reiniciar_nivel()
	container.visible = true

# -------------------
# KILLS
# -------------------
func add_kill():
	_kills += 1
	update_kills_label()


func update_kills_label():
	kills_label.text = "Score: " + str(_kills)


# -------------------
# XP SYSTEM
# -------------------
func add_xp(amount: int):
	xp += amount
	
	if hp == null:
		hp = get_tree().get_first_node_in_group("hp")
		hp.set_max_xp(xp_to_next)
	
	hp.set_xp(xp)
	
	print("XP:", xp, "/", xp_to_next)
	
	if xp >= xp_to_next:
		level_up()
	
	


func level_up():
	
	level += 1
	
	xp_sound.play()
	
	# mantiene XP sobrante
	xp -= xp_to_next
	
	# escala progresiva
	xp_to_next = int(xp_to_next * 1.5)
	
	print("LEVEL UP:", level)
	
	abrir_menu_mejoras()
	
	level_up_pj.emit()

# -------------------
# MENU DE MEJORAS
# -------------------
func abrir_menu_mejoras():
	_leveling_up = true
	
	get_tree().paused = true
	
	var menu = UpgradeMenu.instantiate()
	var canvas = get_node("CanvasLayer") 
	canvas.add_child(menu)     
	
	var opciones = get_random_upgrades()
	menu.setup(opciones, self)


func cerrar_menu_mejoras():
	_leveling_up = false
	get_tree().paused = false
	hp.set_xp(xp)
	hp.set_max_xp(xp_to_next)


# -------------------
# UPGRADES
# -------------------
func get_upgrade_pool():
	var player = get_tree().get_first_node_in_group("player")
	var stone = get_tree().get_first_node_in_group("stone")
	
	return [
		{
			"text": "+Speed",
			"icon": ICON_SPEED,
			"apply": func(): player.upgrade_speed(20)
		},
		{
			"text": "+Daño",
			"icon": ICON_DAMAGE,
			"apply": func(): stone.damage += 4
		},
		{
			"text": "+Vida",
			"icon": ICON_HEALTH,
			"apply": func(): PlayerHpManager.add_max_hp(10)
		}
	]


func get_random_upgrades():
	var pool = get_upgrade_pool()
	pool.shuffle()
	return pool.slice(0, 3)
