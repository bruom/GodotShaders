extends Node3D

@onready var sprite: Sprite3D = $Sprite3D

var texture: Texture2D
var texture_size = nearest_po2(1024)
var image_format

var shader_path: String = "res://Shaders/Grass/compute_grass.glsl"
var rd: RenderingDevice
var image_rid: RID
var shader_rid: RID
var pipeline_rid: RID

func _ready():
	texture = ImageTexture.create_from_image(Image.create(texture_size, texture_size, false, Image.FORMAT_RGBA8))
	sprite.texture = texture

func _process(delta):
	var rand_x = randi_range(0, 1023)
	var rand_y = randi_range(0, 1023)
	var uniforms = prepare_img_for_shader(texture.get_image(), Vector2(rand_x, rand_y))
	var updated_image = compute_image(uniforms)
	texture = ImageTexture.create_from_image(updated_image)
	sprite.texture = texture

func _notification(notif):
	if notif == NOTIFICATION_PREDELETE:
		cleanup_gpu()

func init_gpu():
	rd = RenderingServer.create_local_rendering_device()
	var shader_file_data: RDShaderFile = load(shader_path)
	var shader_spirv: RDShaderSPIRV = shader_file_data.get_spirv()
	shader_rid =  rd.shader_create_from_spirv(shader_spirv)
	pipeline_rid = rd.compute_pipeline_create(shader_rid)
	image_format = RDTextureFormat.new()
	image_format.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	image_format.width = texture_size
	image_format.height = texture_size
	image_format.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT

func prepare_img_for_shader(current_image: Image, draw_pos: Vector2) -> RID:
	if rd == null:
		init_gpu()
	image_rid = rd.texture_create(image_format, RDTextureView.new(), [current_image.get_data()])
	var image_uniform = RDUniform.new()
	image_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	image_uniform.binding = 0
	image_uniform.add_id(image_rid)
	var coord_bytes = PackedFloat32Array([draw_pos.x, draw_pos.y]).to_byte_array()
	var coord_uniform = RDUniform.new()
	coord_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	coord_uniform.binding = 1
	coord_uniform.add_id(rd.storage_buffer_create(coord_bytes.size(), coord_bytes))
	var uniform_set = rd.uniform_set_create([image_uniform, coord_uniform], shader_rid, 0)
	return uniform_set

func compute_image(uniform_set) -> Image:
	if rd == null:
		init_gpu()
	
	var compute_list = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline_rid)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, texture_size/8, texture_size/8, 1)
	rd.compute_list_end()
	
	rd.submit()
	
	rd.sync()
	
	var output_bytes = rd.texture_get_data(image_rid, 0)
	var computed_image = Image.create_from_data(texture_size, texture_size, false, Image.FORMAT_RGBA8, output_bytes)
	return computed_image

func cleanup_gpu():
	if rd == null:
		return

	rd.free_rid(pipeline_rid)
	pipeline_rid = RID()

	rd.free_rid(shader_rid)
	shader_rid = RID()
	
	rd.free_rid(image_rid)
	image_rid = RID()

	rd.free()
	rd = null
