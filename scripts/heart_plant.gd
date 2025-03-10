class_name heart_plant
extends Node2D

func _enter_tree() -> void:
	$PlantSprite.frame = 0 if randi_range(0, 6) else 2

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is DemoPlayer:
		if $PlantSprite.frame % 2 == 0:
			# If heart is not picked
			body.heal(2 if $PlantSprite.frame == 0 else 4)
			$PlantSprite.frame += 1
