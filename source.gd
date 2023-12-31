extends Node3D

@onready var visibility_mat: Material = preload("res://Shaders/Visibility/distance_shroud_mat.tres")

func _process(delta):
	visibility_mat.set_shader_parameter("reference_position", global_position)
	if Input.is_action_pressed("Forward"):
		global_position.z -= 0.01
	if Input.is_action_pressed("Back"):
		global_position.z += 0.01
	if Input.is_action_pressed("Left"):
		global_position.x -= 0.01
	if Input.is_action_pressed("Right"):
		global_position.x += 0.01
