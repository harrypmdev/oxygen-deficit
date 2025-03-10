extends Node2D

func _ready():
	$AudioOff.visible = AudioServer.is_bus_mute(0)

func _on_texture_button_pressed() -> void:
	AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))
	$AudioOff.visible = AudioServer.is_bus_mute(0)
