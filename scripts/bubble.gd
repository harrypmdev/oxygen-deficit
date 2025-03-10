extends CharacterBody2D
var speed = 50
var collided = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(Vector2((speed*delta), 0).rotated(rotation))
	if collision and not collided:
		var colliding_obj = collision.get_collider()
		if colliding_obj is DemoPlayer:
			colliding_obj.o2 = clamp(colliding_obj.o2 + 45, 0, 100)
			$AnimationPlayer.play('absorbed')
			collided = true
		else:
			$CollisionShape2D.disabled = true
			speed = 0
			$AnimationPlayer.play('break')
