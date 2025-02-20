extends CharacterBody2D

@export var teleport_position: Vector2 = Vector2(3000, -4200)
@export var speed: float = 600.0
@export var gravity: float = 500.0
@export var rotation_acceleration: float = 0.1
@export var max_rotation_speed: float = 4.0
@export var min_fall_speed: float = 200.0
@export var max_velocity: float = 800.0  # Max speed limit

var rotation_speed: float = 0.0
var main_script: Node

func _physics_process(_delta: float) -> void:
	velocity.y += gravity * _delta

	if Input.is_action_pressed("main rocket"):
		var direction = Vector2.UP.rotated(rotation)
		velocity += direction * speed * _delta

	if velocity.y < min_fall_speed:
		velocity.y = min_fall_speed

	if Input.is_action_pressed("left rocket"):
		rotation_speed -= rotation_acceleration * _delta
	elif Input.is_action_pressed("right rocket"):
		rotation_speed += rotation_acceleration * _delta

	rotation_speed = clamp(rotation_speed, -max_rotation_speed, max_rotation_speed)
	rotation += rotation_speed * _delta

	# Clamp velocity to the max speed manually
	if velocity.length() > max_velocity:
		velocity = velocity.normalized() * max_velocity

	var collision = move_and_collide(velocity * _delta)

	if collision:
		var collider = collision.get_collider()
		if collider is PhysicsBody2D:
			print("Collided with:", collider)
			teleport()

func teleport():
	position = teleport_position
	velocity = Vector2.ZERO  # Reset speed upon teleportation
	rotation = 0.0  # Reset rotation to default (facing up)
	rotation_speed = 0.0  # Reset rotation speed
