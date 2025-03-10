class_name Small_Fish
extends CharacterBody2D
var speed = 30
var backwards = 1
var motion

func _ready():
	speed = randi_range(1, 5) * 10

func _physics_process(delta: float) -> void:
	move_and_collide(Vector2((speed*delta) * backwards, 0))
	for body in $PlayerArea.get_overlapping_bodies():
		if body is DemoPlayer:
			body.deal_damage(1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not DemoPlayer:
		$FishSprite.flip_h = not $FishSprite.flip_h
		backwards = -backwards

func _on_fish_area_area_entered(area: Area2D) -> void:
	$FishSprite.flip_h = not $FishSprite.flip_h
	backwards = -backwards
