extends Node2D

@export var area_2d: Area2D

var _healing: int = 15

func _ready() -> void:
	area_2d.body_entered.connect(_picked_up)
	pass

func _picked_up(_body):
	PlayerHpManager.change_health(_healing)
	queue_free()
