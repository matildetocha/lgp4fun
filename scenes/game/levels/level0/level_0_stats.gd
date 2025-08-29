extends Node2D

signal end_stats

@export var max_points = "/5"

# Labels
@onready var c2_name: Label = $TextureRect/VBoxContainer/C2/HBoxContainer/CName

# Points
@onready var c2_points: Label = $TextureRect/VBoxContainer/C2/HBoxContainer/Points
@onready var c3_points: Label = $TextureRect/VBoxContainer/C3/HBoxContainer/Points

# Max Points
@onready var c2_max_points: Label = $TextureRect/VBoxContainer/C2/HBoxContainer/MaxPoints
@onready var c3_max_points: Label = $TextureRect/VBoxContainer/C3/HBoxContainer/MaxPoints


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	c2_max_points.text = max_points
	c3_max_points.text = max_points
	
	c2_name.text = GameManager.get_level1_letter().to_upper()
	
	c2_points.text = str(GameManager.get_big_points())
	c3_points.text = str(GameManager.get_sign_points())

func _on_end_button_pressed() -> void:
	end_stats.emit()
