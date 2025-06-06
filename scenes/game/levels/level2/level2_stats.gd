extends Node2D

signal end_stats

@onready var stats = GameManager.level2_stats
@onready var color_rects: Control = $TextureRect/ColorRects

const PATH = "res://assets/dictionary/temas/images/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(stats)
	for i in range(1,5):
		if (stats[i] != ""):
			color_rects.get_child(i-1).visible = false

func _on_end_button_pressed() -> void:
	end_stats.emit()
