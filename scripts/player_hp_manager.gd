extends Node

signal hp_change

var health: int

func _ready():
	health = 100

func change_health(amount: int):
	health -= amount
	hp_change.emit()
