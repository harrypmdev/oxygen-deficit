class_name DemoPlayer
extends CharacterBody2D
@export var max_speed = 85
@export var acceleration = 65
@export var deceleration = 65
@export var collision_cheats = false
@export var item : items = items.NONE
enum items {NONE, MINER, FINS, DRILL}
var turn_speed = 6
var elapsed = 0.0
var o2 = 100
var health = 8
var dead = false
const acc = 1
var damage_disabled = false

func _ready():
	if item == items.MINER:
		for child in get_parent().get_children():
			if child is PointLight2D:
				print("here")
				child.energy = 1.4
				child.texture_scale = 14
				

func _physics_process(delta: float) -> void:
	var ms := get_global_mouse_position()
	if (Input.is_mouse_button_pressed(1) and position.distance_to(ms) > 3) and not dead:
		$AnimationPlayer.play("swimming")
		if ms.x < position.x:
			$DiverSprite.flip_v = true
		else:
			$DiverSprite.flip_v = false
		var target_angle := (ms - global_position).angle()
		rotation = lerp_angle(rotation, target_angle, turn_speed * delta)
		
		var target_velocity = Vector2(max_speed, 0).rotated(rotation)
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		$AnimationPlayer.play("idle")
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	move_and_slide()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_mouse_click") and collision_cheats:
		$CollisionShape2D.disabled = not $CollisionShape2D.disabled
	
func _on_timer_timeout() -> void:
	if o2 > 0 and not dead:
		o2 -= 1
	else:
		if not dead:
			dead = true
			$DamagePlayer.play("o2_death")

func deal_damage(damage: int):
	if not damage_disabled and not dead:
		health = clamp(health - damage, 0, 8)
		if health == 0:
			dead = true
			$DamagePlayer.play("death")
		else:
			$DamagePlayer.play("damage")
			damage_disabled = true

func safety_ended():
	damage_disabled = false

func heal(points: int):
	health = clamp(health + points, 0, 8)
