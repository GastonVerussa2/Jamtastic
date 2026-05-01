extends Node

var sound_volume: float = 1.0
var music_volume: float = 1.0

func change_sound_volume(new_volume: float):
	sound_volume = new_volume / 100
	for player in get_tree().get_nodes_in_group("sound") as Array[AudioStreamPlayer2D]:
		player.volume_linear = sound_volume

func change_music_volume(new_volume: float):
	music_volume = new_volume / 100
	for player in get_tree().get_nodes_in_group("music") as Array[AudioStreamPlayer2D]:
		player.volume_linear = music_volume

func get_sound() -> float:
	return sound_volume

func get_music() -> float:
	return music_volume
	
