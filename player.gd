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
var moving: bool = false 
var controls_enabled: bool = true

var win_condition_met: bool = false

func _physics_process(_delta: float) -> void:
	velocity.y += gravity * _delta
	
	if controls_enabled:
		if Input.is_action_pressed("main rocket"):
			print("w key pressed")
			var direction = Vector2.UP.rotated(rotation)
			velocity += speed * direction * _delta  # Apply thrust
			
		if Input.is_action_pressed("left rocket"):
			rotation_speed -= rotation_acceleration * _delta
		elif Input.is_action_pressed("right rocket"):
			rotation_speed += rotation_acceleration * _delta

		rotation_speed = clamp(rotation_speed, -max_rotation_speed, max_rotation_speed)
		rotation += rotation_speed * _delta
	else:
		print("controls disabled")
		rotation_speed = 0.0  # Prevent further rotation
		velocity.x = 0  # Stop horizontal movement from input

	if velocity.length() > max_velocity:
		velocity = velocity.normalized() * max_velocity

	var collision = move_and_collide(velocity * _delta)

	if collision:
		var collider = collision.get_collider()
		if collider is PhysicsBody2D:
			print("Collided with:", collider)
			
			if abs(velocity.y) < 200:
				print("You win")
				win_condition_met = true
				get_tree().change_scene_to_file("res://win_menu.tscn")
			else:
				print("You Loose")
				get_tree().change_scene_to_file("res://loosemenu.tscn")

func teleport():
	position = Vector2(3000, -4200)  # Reset to the teleport position
	velocity = Vector2.ZERO  # Reset speed
	rotation = 0.0  # Reset rotation
	rotation_speed = 0.0  # Reset rotation speed

func disable_controls():
	print("fuel empty")
	controls_enabled = false  # Player can no longer apply thrust or rotation
	velocity.x = 0
