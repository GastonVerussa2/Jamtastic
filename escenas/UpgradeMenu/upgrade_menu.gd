extends Control

var upgrades = []
var main

@export var btns: Array[Button]
@export var labels: Array[Label]
@export var textures: Array[TextureRect]
@export var choose_sounds: Array[AudioStreamPlayer2D]
@export var patches: Array[NinePatchRect]

func _ready():
	for i in btns.size():
		btns[i].mouse_entered.connect(func(): hovered_over(i))
		btns[i].mouse_exited.connect(func(): mouse_left(i))
	for sound in choose_sounds:
		sound.volume_linear = SoundManager.get_sound()

func setup(options: Array, main_ref):
	
	upgrades = options
	main = main_ref
	
	for i in btns.size():
		patches[i].modulate = Color(patches[i].modulate.r * 0.75, patches[i].modulate.g * 0.75, patches[i].modulate.b * 0.75, patches[i].modulate.a)
		btns[i].disabled = true
		_configurar_boton(i, options[i])
		btns[i].pressed.connect(func(): _on_selected(i))
	
	await get_tree().create_timer(0.5).timeout
	
	for btn in btns:
		btn.disabled = false
	
	for patch in patches:
		patch.modulate = Color(patch.modulate.r / 0.75, patch.modulate.g / 0.75, patch.modulate.b / 0.75, patch.modulate.a)


func _configurar_boton(i: int, data):
	labels[i].text = data["text"]
	textures[i].texture = data.get("icon", null)


func _on_selected(index):
	var upgrade = upgrades[index]
	upgrade["apply"].call()
	
	main.cerrar_menu_mejoras()
	queue_free()

func mouse_left(i: int):
	if btns[i].disabled == false:
		patches[i].modulate = Color(patches[i].modulate.r / 1.35, patches[i].modulate.g / 1.35, patches[i].modulate.b / 1.35, patches[i].modulate.a) 

func hovered_over(i: int):
	choose_sounds[randi_range(0,choose_sounds.size() - 1)].play()
	if btns[i].disabled == false:
		patches[i].modulate = Color(patches[i].modulate.r * 1.35, patches[i].modulate.g * 1.35, patches[i].modulate.b * 1.35, patches[i].modulate.a) 
