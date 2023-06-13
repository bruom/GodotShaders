extends Node3D

@onready var main_camera: Camera3D = $Camera3D
@onready var outline_viewport: Viewport = $Camera3D/OutlineViewport
@onready var quad: MeshInstance3D = $Camera3D/OutlineViewport/OutlineCamera/MeshInstance3D
@onready var res_sprite = $Camera3D/Sprite3D

func _process(delta):
	await RenderingServer.frame_post_draw
	var viewport = outline_viewport.get_texture()
	var main_img = get_viewport().get_texture().get_image()
	var outline_img = outline_viewport.get_texture().get_image()
	#main_img.blit_rect(outline_img, outline_img.get_used_rect(), Vector2i.ZERO)
	var tex = ImageTexture.create_from_image(outline_img)
	res_sprite.texture = tex
