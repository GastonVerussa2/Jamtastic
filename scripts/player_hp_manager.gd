extends Node

signal hp_change

var health: int
var max_health: int = 100

var _base_max_health: int = 100


func _ready():
	max_health = _base_max_health
	health = max_health


# -------------------
# CAMBIAR VIDA
# -------------------
func change_health(amount: int):
	health += amount
	
	if health > max_health:
		health = max_health
	elif health < 0:
		health = 0
	
	hp_change.emit()


# -------------------
# RESET 
# -------------------
func reset_life():
	max_health = _base_max_health
	health = max_health
	
	hp_change.emit()

# -------------------
# UPGRADE VIDA
# -------------------
func add_max_hp(amount: int):
	max_health += amount
	
	health += amount
	
	if health > max_health:
		health = max_health
	
	hp_change.emit()
