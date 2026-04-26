extends Node2D

@export var niveles: Array[PackedScene]

var _nivel_actual: int = 1
var _nivel_instanciado: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_crear_nivel(_nivel_actual)

func _crear_nivel(numero_nivel: int):
	_nivel_instanciado = niveles[numero_nivel - 1].instantiate()
	add_child(_nivel_instanciado)
	
	var hijos: Array = _nivel_instanciado.get_children()
	# Tambien podria ser var personajes := get_tree().get_nodes_in_group("personajes")
	
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

func avanzar_nivel():
	_nivel_actual += 1
	_reiniciar_nivel()
