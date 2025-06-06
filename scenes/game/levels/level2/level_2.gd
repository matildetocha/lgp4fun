extends Node2D

signal go_back
signal level2_over
signal show_level_stats

# Left Puzzle
@onready var video: VideoStreamPlayer = $UI/VocabControl/HBoxContainer/Left/VideoStreamPlayer
@onready var left_color_rect: ColorRect = $UI/VocabControl/HBoxContainer/Left/ColorRect

# Middle Puzzle
@onready var image: TextureRect = $UI/VocabControl/HBoxContainer/Middle/TextureRect
@onready var middle_color_rect: ColorRect = $UI/VocabControl/HBoxContainer/Middle/ColorRect

# Right Puzzle
@onready var word: Label = $UI/VocabControl/HBoxContainer/Right/Label
@onready var right_color_rect: ColorRect = $UI/VocabControl/HBoxContainer/Right/ColorRect

const MAX_VOCAB = 5

var current_word = ""
var counter = 1
var vocab_words = ["mãe", "pai", "avô", "avó", "mãe"]
var vocab_learned = []

const VIDEO_PATH = "res://assets/dictionary/temas/videos/"
const IMAGE_PATH = "res://assets/dictionary/temas/images/"

@onready var collectables: Node2D = $Collectables
@onready var end: Node2D = $Collectables/End
@onready var terrain_areas: Node2D = $TerrainAreas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.connect("game_over", goto_game_over)
	end.connect("end_game", end_level_2)
	terrain_areas.connect("next_vocab_level", reset_word)	
	set_current_word()
	
func _on_back_button_pressed() -> void:
	go_back.emit()
	
func goto_game_over() -> void:
	level2_over.emit()

func end_level_2() -> void:
	GameManager.set_level2_stats(vocab_learned)
	show_level_stats.emit()		
	
func get_current_word() -> String:
	return current_word
	
func set_current_word() -> void:
	current_word = vocab_words[terrain_areas.current_vocab_level]
	
func add_vocab(new_word: String) -> void:
	vocab_learned.append(new_word)

func add_counter() -> void:	
	if (counter <= 3):
		counter += 1
		
func vocab_assembly(type: String) -> void:
	if (type == "video"):
		video.stream = load(VIDEO_PATH + current_word + ".ogv")
		video.play()
		left_color_rect.visible = false
		
		add_counter()
		
	elif (type == "image"):
		image.texture = load(IMAGE_PATH + current_word + ".png")
		image.visible = true
		middle_color_rect.visible = false

		add_counter()
		
	elif (type == "word"):
		word.text = current_word
		right_color_rect.visible = false
		
		add_counter()

func vocab_tip() -> void:
	if (current_word == "pai"):
		video.stream = load(VIDEO_PATH + current_word + ".ogv")
		video.play()
		left_color_rect.visible = false
		
	elif (current_word == "avô"):
		word.text = current_word
		right_color_rect.visible = false
		
	elif (current_word == "avó"):
		image.texture = load(IMAGE_PATH + current_word + ".png")
		image.visible = true
		middle_color_rect.visible = false
	
	elif (current_word == "mãe"):
		word.text = current_word
		right_color_rect.visible = false
		
func reset_word() -> void:
	if (counter == 3):
		add_vocab(current_word)
	else:
		add_vocab("")
	await get_tree().create_timer(1.5).timeout
	
	video.stop()
	left_color_rect.visible = true
	
	image.visible = false
	middle_color_rect.visible = true
	
	word.text = ""
	right_color_rect.visible = true
	
	if (terrain_areas.current_vocab_level < MAX_VOCAB):
		set_current_word()
		vocab_tip()
		counter = 1
		
	else:
		counter = 0

func _on_timer_timeout() -> void:
	collectables.play_videos()
