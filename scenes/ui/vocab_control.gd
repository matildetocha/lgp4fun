extends Container

# Left Puzzle
@onready var video: VideoStreamPlayer = $HBoxContainer/Left/VideoStreamPlayer
@onready var left_color_rect: ColorRect = $HBoxContainer/Left/ColorRect
@onready var left_check_icon: TextureRect = $HBoxContainer/Left/CheckIcon

# Middle Puzzle
@onready var image: TextureRect = $HBoxContainer/Middle/TextureRect
@onready var middle_color_rect: ColorRect = $HBoxContainer/Middle/ColorRect
@onready var middle_check_icon: TextureRect = $HBoxContainer/Middle/CheckIcon

# Right Puzzle
@onready var word: Label = $HBoxContainer/Right/Label
@onready var right_color_rect: ColorRect = $HBoxContainer/Right/ColorRect
@onready var right_check_icon: TextureRect = $HBoxContainer/Right/CheckIcon

func _process(_delta: float) -> void:
	if (left_color_rect.visible == false
		&& middle_color_rect.visible == false
		&& right_color_rect.visible == false):
		left_check_icon.visible = true
		middle_check_icon.visible = true
		right_check_icon.visible = true
	else:
		left_check_icon.visible = false
		middle_check_icon.visible = false
		right_check_icon.visible = false
