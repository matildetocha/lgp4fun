extends Node2D

@onready var images_node: Node2D = $Images
@onready var words_node: Node2D = $Words
@onready var videos_node: Node2D = $Videos

@onready var level2 = $".."
@onready var vocab_checks: Node2D = $"../TerrainAreas/"

var vocab_words = []
var images = []
var words = []
var videos = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level2.connect("populate", populate_collectables)
	vocab_checks.connect("play_video", play_next_video)
	vocab_words = level2.vocab_words
	
	images = images_node.get_children()
	words = words_node.get_children()
	videos = videos_node.get_children()

func populate_collectables() -> void:
	randomize()
	
	# Populate tutorial collectables
	words[0].get_child(0).text = vocab_words[0][0]
	words[0].add_to_group("collectables")
	
	images[0].get_node("Panel").get_child(1).texture = vocab_words[0][1]
	images[0].add_to_group("collectables")
	
	# Populate rest of collectables with random correct/ incorrect placement
	for i in range(1, vocab_words.size()):
		match i:
			1: # First vocab: (word1, word2), (image1, image2)
				populate_word([1, 2], i, get_random_incorrect_index(i))
				populate_image([1, 2], i, get_random_incorrect_index(i))	
			2: # Second vocab (video0, video1), (image3, image4)
				populate_video([0, 1], i, get_random_incorrect_index(i))
				populate_image([3, 4], i, get_random_incorrect_index(i))
			3: # Third vocab (video2, video3), (word3, word4)
				populate_video([2, 3], i, get_random_incorrect_index(i))
				populate_word([3, 4], i, get_random_incorrect_index(i))
			4: 	# Fourht vocab (image5, image6), (video4, video5)
				populate_video([4, 5], i, get_random_incorrect_index(i))
				populate_image([5, 6], i, get_random_incorrect_index(i))

# Helper function to get a random incorrect index different from the correct one
func get_random_incorrect_index(correct_index):
	randomize()
	var choices = []
	for i in range(vocab_words.size()):
		if i != correct_index:
			choices.append(i)
	return choices[randi() % choices.size()]

func populate_word(word_indexes: Array, current_vocab: int, incorrect_vocab: int) -> void:
	var correct_idx = randi_range(word_indexes[0], word_indexes[1])
	
	for i in word_indexes:
		if i == correct_idx:
			words[i].get_child(0).text = vocab_words[current_vocab][0]
			words[i].add_to_group("collectables")
		else:
			words[i].get_child(0).text = vocab_words[incorrect_vocab][0]
			words[i].add_to_group("enemies")

func populate_image(image_indexes: Array, current_vocab:int, incorrect_vocab: int) -> void:
	var correct_idx = randi_range(image_indexes[0], image_indexes[1])
	
	for i in image_indexes:
		if i == correct_idx:
			images[i].get_node("Panel").get_child(1).texture = vocab_words[current_vocab][1]
			images[i].add_to_group("collectables")
		else:
			images[i].get_node("Panel").get_child(1).texture = vocab_words[incorrect_vocab][1]
			images[i].add_to_group("enemies")

func populate_video(video_indexes: Array, current_vocab:int, incorrect_vocab: int) -> void:
	var correct_idx = randi_range(video_indexes[0], video_indexes[1])
	
	for i in video_indexes:
		if i == correct_idx:
			videos[i].get_node("Panel").get_child(1).stream = load(vocab_words[current_vocab][2])
			videos[i].add_to_group("collectables")
		else:
			videos[i].get_node("Panel").get_child(1).stream = load(vocab_words[incorrect_vocab][2])
			videos[i].add_to_group("enemies")

func play_next_video(current_vocab: int) -> void:
	match current_vocab:
		2:
			videos[0].get_node("Panel").get_child(1).play()
			videos[1].get_node("Panel").get_child(1).play()
		3:
			videos[2].get_node("Panel").get_child(1).play()
			videos[3].get_node("Panel").get_child(1).play()
		4:
			videos[4].get_node("Panel").get_child(1).play()
			videos[5].get_node("Panel").get_child(1).play()
		_:
			pass
