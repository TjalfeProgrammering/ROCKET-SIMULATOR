extends Node2D

# Node references
@onready var character_body = $RigidBody2D # Update this to the actual name if different
@onready var label = $CanvasLayer/MarginContainer/VBoxContainer/Label

func _ready():
	# Initialize the label text
	label.text = "Fall Speed: 0 px/s"

func _physics_process(delta):
	# Get the CharacterBody2D's velocity along the y-axis
	var fall_speed = character_body.velocity.y

	# Only display speed if falling (positive y velocity)
	if fall_speed > 0:
		label.text = "Fall Speed: " + str(round(fall_speed)) + " px/s"
	else:
		label.text = "Fall Speed: 0 px/s"
