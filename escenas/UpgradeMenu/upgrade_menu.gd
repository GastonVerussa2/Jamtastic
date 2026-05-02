extends Control

var upgrades = []
var main

@onready var btn1: Button = $Panel/VBoxContainer/Button
@onready var btn2: Button = $Panel/VBoxContainer/Button2
@onready var btn3: Button  = $Panel/VBoxContainer/Button3

@export var choose_sounds: Array[AudioStreamPlayer2D]

func _ready():
	btn1.mouse_entered.connect(hovered_over)
	btn2.mouse_entered.connect(hovered_over)
	btn3.mouse_entered.connect(hovered_over)

func setup(options: Array, main_ref):
	btn1.disabled = true
	btn2.disabled = true
	btn3.disabled = true
	
	upgrades = options
	main = main_ref
	
	_configurar_boton(btn1, options[0])
	_configurar_boton(btn2, options[1])
	_configurar_boton(btn3, options[2])
	
	btn1.pressed.connect(func(): _on_selected(0))
	btn2.pressed.connect(func(): _on_selected(1))
	btn3.pressed.connect(func(): _on_selected(2))
	
	await get_tree().create_timer(0.5).timeout
	
	btn1.disabled = false
	btn2.disabled = false
	btn3.disabled = false


func _configurar_boton(btn: Button, data):
	btn.text = data["text"]
	btn.icon = data.get("icon", null)


func _on_selected(index):
	var upgrade = upgrades[index]
	upgrade["apply"].call()
	
	main.cerrar_menu_mejoras()
	queue_free()

func hovered_over():
	choose_sounds[randi_range(0,choose_sounds.size() - 1)].play()
