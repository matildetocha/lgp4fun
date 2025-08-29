extends Control

@onready var level_letter = GameManager.get_level1_letter()

# Letters 
@onready var big_letter_label: Label = $LetterContainer/BigLetterLabel
@onready var lgp_image: TextureRect = $LetterContainer/Panel/LGPImage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	big_letter_label.text = level_letter.to_upper()
	lgp_image.texture = load("res://assets/dictionary/configuration/" + level_letter.to_upper() + ".svg")
