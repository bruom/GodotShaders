extends MeshInstance3D

func _process(delta):
	
	if Input.is_action_pressed("Forward"):
		global_rotation.z -= 0.02
	if Input.is_action_pressed("Back"):
		global_rotation.z += 0.02
	if Input.is_action_pressed("Left"):
		global_rotation.x -= 0.02
	if Input.is_action_pressed("Right"):
		global_rotation.x += 0.02
