extends Node

signal hp_change

var health: int
var max_health: int = 180

func _ready():
	health = max_health
	

func change_health(amount: int):
	health += amount
	if(health > max_health):
		health = max_health
	elif(health < 0):
		health = 0
	hp_change.emit()
