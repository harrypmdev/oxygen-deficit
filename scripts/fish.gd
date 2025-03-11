class_name Fish
extends CharacterBody2D
var speed = 30
var backwards = 1

func _ready():
	speed = randi_range(1, 3) * 10

func _physics_process(delta: float) -> void:
	move_and_collide(Vector2((speed*delta) * backwards, 0))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not DemoPlayer:
		$FishSprite.flip_h = not $FishSprite.flip_h
		$BiteArea.position.x = -25 if $FishSprite.flip_h else 0
		backwards = -backwards

func _on_player_area_body_entered(body: Node2D) -> void:
	if body is DemoPlayer:
		body.deal_damage(2)

func _on_fish_area_area_entered(_area: Area2D) -> void:
	$FishSprite.flip_h = not $FishSprite.flip_h
	$BiteArea.position.x = -25 if $FishSprite.flip_h else 0
	$BiteArea/UpDownCollider.position.x = -0.5 if $FishSprite.flip_h else 25.5
	backwards = -backwards

func _on_bite_area_body_entered(body: Node2D) -> void:
	if body is DemoPlayer:
		$FishSprite.frame = 1

func _on_bite_area_body_exited(body: Node2D) -> void:
	if body is DemoPlayer:
		$FishSprite.frame = 0
