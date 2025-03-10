class_name o2_plant
extends Node2D
@export var needs_player = true
var bubble = preload("res://scenes/bubble.tscn")
var current_bubble


func _on_timer_timeout() -> void:
	for body in $Area2D.get_overlapping_bodies():
		if body is DemoPlayer or not needs_player:
			var bubble_instance = bubble.instantiate()
			bubble_instance.z_index = -1
			bubble_instance.position.x = 3
			bubble_instance.rotation = self.rotation
			$AnimationPlayer.play('create')
			add_child(bubble_instance)
			
