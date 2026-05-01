class_name PauseMenu

extends Control

@export var unpause_button: Button
@export var timer: Timer
@export var canvas: CanvasLayer
@export var music_slider: HSlider
@export var sound_slider: HSlider
@export var pause_sound: AudioStreamPlayer2D
@export var quit_button: Button

var main_scene: MainScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas.visible = false
	unpause_button.pressed.connect(_unpause)
	music_slider.drag_ended.connect(change_music)
	sound_slider.drag_ended.connect(change_sound)
	quit_button.pressed.connect(quit_game)
	main_scene = get_tree().get_first_node_in_group("main")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pausasa") && timer.is_stopped() && not main_scene._leveling_up:
		_unpause()
	
func quit_game():
	get_tree().quit()

func _unpause():
	canvas.visible = false
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false

func change_music(changed: bool):
	if changed:
		SoundManager.change_music_volume(music_slider.value)
		print("nuevo valor musica ")
		print(music_slider.value)
	
func change_sound(changed: bool):
	if changed:
		SoundManager.change_sound_volume(sound_slider.value)
		print("nuevo valor sonidos ")
		print(sound_slider.value)

func pausar():
	timer.start()
	pause_sound.play()
	canvas.visible = true
