extends Control

@export var label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerHpManager.hp_change.connect(_refresh_text)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _refresh_text():
	label.text = "HP: " + str(PlayerHpManager.health)
	
