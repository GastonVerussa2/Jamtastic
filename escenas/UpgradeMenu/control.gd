extends Control

var upgrades = []
var main

@onready var btn1 = $Panel/VBoxContainer/Button
@onready var btn2 = $Panel/VBoxContainer/Button2
@onready var btn3 = $Panel/VBoxContainer/Button3


func setup(options: Array, main_ref):
	upgrades = options
	main = main_ref
	
	_configurar_boton(btn1, options[0])
	_configurar_boton(btn2, options[1])
	_configurar_boton(btn3, options[2])
	
	btn1.pressed.connect(func(): _on_selected(0))
	btn2.pressed.connect(func(): _on_selected(1))
	btn3.pressed.connect(func(): _on_selected(2))


func _configurar_boton(btn: Button, data):
	btn.text = data["text"]
	btn.icon = data.get("icon", null)


func _on_selected(index):
	var upgrade = upgrades[index]
	upgrade["apply"].call()
	
	main.cerrar_menu_mejoras()
	queue_free()
