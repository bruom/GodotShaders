@tool
extends Node3D

@onready var canvas = $"../Canvas"

func _process(delta):
	RenderingServer.global_shader_parameter_set("player_position", global_position);
	if not Engine.is_editor_hint():
		canvas.test_draw(Vector2(global_position.x * 100, global_position.z * 100))
		
		if Input.is_action_pressed("Forward"):
			global_position.z -= 0.02
		if Input.is_action_pressed("Back"):
			global_position.z += 0.02
		if Input.is_action_pressed("Left"):
			global_position.x -= 0.02
		if Input.is_action_pressed("Right"):
			global_position.x += 0.02
