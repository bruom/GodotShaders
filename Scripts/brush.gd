extends TextureRect

@onready var a = load("res://Shaders/Grass/beamSimple.png")
var circle_draw_queue = []
var texture_draw_queue: Array[Texture2D] = []

func _process(delta):
	queue_redraw()

func test_draw(uv_position: Vector2):
	circle_draw_queue.push_back(uv_position)
	queue_redraw()

func draw_full_texture(tex: Texture2D):
	if tex != null:
		texture_draw_queue.push_back(tex)
		queue_redraw()

func _draw():
	draw_rect(Rect2(0.0,0.0,1024.0,1024.0), Color(0.0,0.0,0.0,0.01))
	
	for d in circle_draw_queue:
		draw_circle(d, 90, Color.RED)
	circle_draw_queue = []
	

