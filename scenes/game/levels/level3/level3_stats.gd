extends Node2D

signal end_stats

@onready var stats = GameManager.level3_stats
@onready var color_rects: Control = $TextureRect/ColorRects
@onready var v_box_container: VBoxContainer = $TextureRect/VBoxContainer
@onready var http_request: AwaitableHTTPRequest = $AwaitableHTTPRequest

var current_i = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	for i in range(1,5):
		current_i = i
		v_box_container.get_child(i-1).get_child(1).text = stats[1][i]["name"].to_lower()
		
		if (stats[1][i]["image"]):
			var resp = await http_request.async_request(stats[1][i]["image"])
			var img = Image.new()
			var err = img.load_png_from_buffer(resp.bytes)
			if resp.success():
				if err == OK:
					var texture = ImageTexture.create_from_image(img)
					v_box_container.get_child(current_i-1).get_child(0).texture = texture
				
		if (stats[1][i]["name"].to_lower() in stats[0]):
			color_rects.get_child(i-1).visible = false
		
		v_box_container.get_child(i-1).get_child(0).visible = true
		v_box_container.get_child(i-1).get_child(1).visible = true

func _on_end_button_pressed() -> void:
	end_stats.emit()
