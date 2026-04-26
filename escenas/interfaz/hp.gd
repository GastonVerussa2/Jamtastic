extends Control

@export var label: Label
@export var progress_bar: ProgressBar
@export var texture_progress_bar: TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerHpManager.hp_change.connect(_refresh_text)
	progress_bar.max_value = float(PlayerHpManager.health)
	progress_bar.value = float(PlayerHpManager.health)
	texture_progress_bar.max_value = float(PlayerHpManager.health)
	texture_progress_bar.value = float(PlayerHpManager.health)
	var sb = StyleBoxFlat.new()
	progress_bar.add_theme_stylebox_override("fill", sb)
	sb.bg_color = Color("ff0000")
	label.text = "HP: " + str(PlayerHpManager.health)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _refresh_text():
	label.text = "HP: " + str(PlayerHpManager.health)
	progress_bar.value = float(PlayerHpManager.health)
	texture_progress_bar.value = float(PlayerHpManager.health) 
	print(texture_progress_bar.value)
	
