extends Node2D

@export var niveles: Array[PackedScene]
@export var kills_label: Label

const UpgradeMenu = preload("res://escenas/UpgradeMenu/control.tscn") 

const ICON_SPEED = preload("res://sprites/SPEED_UP.png")
const ICON_DAMAGE = preload("res://sprites/dano_up.png")
const ICON_HEALTH = preload("res://sprites/Corazon_hp_up.png")

var _nivel_actual: int = 1
var _nivel_instanciado: Node

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


func _ready() -> void:
	add_to_group("main")
	_crear_nivel(_nivel_actual)
	update_kills_label()


func _crear_nivel(numero_nivel: int):
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
	_crear_nivel.call_deferred(_nivel_actual)
	PlayerHpManager.reset_life()


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
	
	print("XP:", xp, "/", xp_to_next)
	
	if xp >= xp_to_next:
		level_up()


func level_up():
	level += 1
	
	# mantiene XP sobrante
	xp -= xp_to_next
	
	# escala progresiva
	xp_to_next = int(xp_to_next * 1.5)
	
	print("LEVEL UP:", level)
	
	abrir_menu_mejoras()


# -------------------
# MENU DE MEJORAS
# -------------------
func abrir_menu_mejoras():
	get_tree().paused = true
	
	var menu = UpgradeMenu.instantiate()
	var canvas = get_node("CanvasLayer") 
	canvas.add_child(menu)     
	
	var opciones = get_random_upgrades()
	menu.setup(opciones, self)


func cerrar_menu_mejoras():
	get_tree().paused = false


# -------------------
# UPGRADES
# -------------------
func get_upgrade_pool():
	var player = get_tree().get_first_node_in_group("player")
	
	return [
		{
			"text": "+Speed",
			"icon": ICON_SPEED,
			"apply": func(): player.speed += 20
		},
		{
			"text": "+Daño",
			"icon": ICON_DAMAGE,
			"apply": func(): player.damage += 1
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
