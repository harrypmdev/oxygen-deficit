extends Node2D

func _enter_tree() -> void:
	$PlantSprite.frame = randi_range(0, 7)
