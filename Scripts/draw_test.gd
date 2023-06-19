extends Node3D

@onready var canvas = $Canvas
@onready var sprite = $Sprite3D
var brush_position: Vector2 = Vector2(50, 50)

func _process(delta):
	var outline_img = canvas.get_texture().get_image()
	#main_img.blit_rect(outline_img, outline_img.get_used_rect(), Vector2i.ZERO)
	var tex = ImageTexture.create_from_image(outline_img)
	sprite.texture = tex
	
	
	if Input.is_action_pressed("Forward"):
		brush_position.y -= 1
	if Input.is_action_pressed("Back"):
		brush_position.y += 1
	if Input.is_action_pressed("Left"):
		brush_position.x -= 1
	if Input.is_action_pressed("Right"):
		brush_position.x += 1
	if Input.is_action_pressed("Space"):
		canvas.test_draw(brush_position)
