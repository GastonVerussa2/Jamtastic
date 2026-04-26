extends Node2D

@export var first_text: Label
@export var second_text: Label
@export var third_text: Label
@export var forth_text: Label
@export var tutorial_1: Label
@export var tutorial_2: Label
@export var writing_sound_1: AudioStreamPlayer2D
@export var writing_sound_2: AudioStreamPlayer2D
@export var gregorio_node: Node2D
@export var protagonist: Sprite2D
@export var arfurro: Sprite2D

var writing_speed: float = 0.2

var left_text: Label
var right_text: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_text = first_text
	right_text = second_text
	first_text.visible_ratio = 0
	second_text.visible_ratio = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if left_text.visible_ratio < 1:
		left_text.visible_ratio += writing_speed * delta;
		if !writing_sound_1.playing:
			writing_sound_1.play()
	elif right_text.visible_ratio < 1:
		right_text.visible_ratio += writing_speed * delta;
		if !writing_sound_2.playing:
			writing_sound_2.play()
		
	if left_text.visible_ratio == 1:
			writing_sound_1.stop()
	if right_text.visible_ratio == 1:
			writing_sound_2.stop()
	
	# Si estamos en la ultima pagina
	if left_text.visible_ratio == 1 && right_text == tutorial_2 && not protagonist.visible:
		protagonist.visible = true
		arfurro.visible = true
		
	# Si estamos en la ultima pagina
	if left_text.visible_ratio == 1 && right_text == tutorial_2 && Input.is_action_just_pressed("gregory"):
		gregorio_node.visible = true
		arfurro.visible = false
		
	
	if Input.is_action_just_pressed("dash") || Input.is_action_just_pressed("right"):
		_pasar_pagina()

func _pasar_pagina():
	if left_text == first_text:
		left_text.visible_ratio = 0
		right_text.visible_ratio = 0
		left_text = third_text
		right_text = forth_text
		left_text.visible_ratio = 0
		right_text.visible_ratio = 0
	elif left_text == third_text:
		left_text.visible_ratio = 0
		right_text.visible_ratio = 0
		left_text = tutorial_1
		right_text = tutorial_2
		left_text.visible_ratio = 0
		right_text.visible_ratio = 0
	else:
		pass
		# va al juegaso
