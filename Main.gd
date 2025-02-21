extends Node2D

# Node references
@onready var character_body: CharacterBody2D = $RigidBody2D  # Update this to your character
@onready var label: Label = $CanvasLayer/MarginContainer/VBoxContainer/Label
@onready var label_2: Label = $CanvasLayer/MarginContainer/VBoxContainer/Label2
@onready var ground: StaticBody2D = $ground  # Ensure 'ground' is the StaticBody2D node for your floor
@onready var label_3: Label = $CanvasLayer/MarginContainer/VBoxContainer/Label3

var fuel: float = 100.0 

func _ready():
	# Initialize the label texts
	label.text = "Fall Speed: 0 px/s"
	label_2.text = "Altitude: 0 px"
	label_3.text = "Fuel: " + str(fuel) + "%"

func _physics_process(delta):
	# Get the velocity of the character along the y-axis
	var fall_speed = character_body.velocity.y
	if (Input.is_action_pressed("main rocket") or Input.is_action_pressed("left rocket") or Input.is_action_pressed("right rocket")) and fuel > 0:
		fuel -= delta * 5  # Decrease fuel over time when keys are pressed (you can adjust the rate)
		fuel = max(fuel, 0)  # Prevent fuel from going below 0
		label_3.text = "Fuel: " + str(round(fuel)) + "%"
	
	if fuel <= 0:
		character_body.disable_controls()
	
	# Update the label with the fall speed, only if falling (positive y velocity)
	if fall_speed > 0:
		label.text = "Fall Speed: " + str(round(fall_speed)) + " px/s"
	else:
		label.text = "Fall Speed: 0 px/s"
		
	# Ensure the ground is a valid reference
	if ground:
		# Calculate the altitude difference (Y-axis)
		var altitude = abs(character_body.global_position.y - ground.global_position.y)
		label_2.text = "Altitude: " + str(round(altitude)) + " px"
