extends Node2D

@onready var images_node: Node2D = $Images
@onready var words_node: Node2D = $Words
@onready var videos_node: Node2D = $Videos

var videos_to_play = []
var vocab_words = ["mãe", "pai", "avô", "avó"];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_collectables()

func populate_collectables() -> void:
	var images = images_node.get_children()
	var words = words_node.get_children()
	var videos = videos_node.get_children()
	
	# Populate Images
	images[0].add_to_group("collectables")
	images[1].add_to_group("collectables")
	images[1].get_node("Panel").get_child(1).texture = load("res://assets/dictionary/temas/images/pai.png")
	images[2].add_to_group("enemies")
	images[2].get_node("Panel").get_child(1).texture = load("res://assets/dictionary/temas/images/avó.png")
	images[3].add_to_group("collectables")
	images[3].get_node("Panel").get_child(1).texture = load("res://assets/dictionary/temas/images/avô.png")
	images[4].add_to_group("enemies")
	images[4].get_node("Panel").get_child(1).texture = load("res://assets/dictionary/temas/images/mãe.png")
	images[5].add_to_group("enemies")
	images[5].get_node("Panel").get_child(1).texture = load("res://assets/dictionary/temas/images/pai.png")
	images[6].add_to_group("collectables")
	images[6].get_node("Panel").get_child(1).texture = load("res://assets/dictionary/temas/images/mãe.png")
	
	# Populate Words
	words[0].add_to_group("collectables")
	words[1].add_to_group("enemies")
	words[1].get_child(0).text = "mãe"
	words[2].add_to_group("collectables")
	words[2].get_child(0).text = "pai"
	words[3].add_to_group("collectables")
	words[3].get_child(0).text = "avó"
	words[4].add_to_group("enemies")
	words[4].get_child(0).text = "pai"
	
	# Populate Videos
	videos[0].add_to_group("enemies")
	videos[0].get_node("Panel").get_child(1).stream = load("res://assets/dictionary/temas/videos/pai.ogv")
	videos[0].get_node("Panel").get_child(1).play()
	videos[1].add_to_group("collectables")
	videos[1].get_node("Panel").get_child(1).stream = load("res://assets/dictionary/temas/videos/avô.ogv")
	videos[1].get_node("Panel").get_child(1).play()
	videos[2].add_to_group("enemies")
	videos[2].get_node("Panel").get_child(1).stream = load("res://assets/dictionary/temas/videos/avô.ogv")
	videos[2].get_node("Panel").get_child(1).play()
	videos[3].add_to_group("collectables")
	videos[3].get_node("Panel").get_child(1).stream = load("res://assets/dictionary/temas/videos/avó.ogv")
	videos[3].get_node("Panel").get_child(1).play()
	videos[4].add_to_group("collectables")
	videos[4].get_node("Panel").get_child(1).stream = load("res://assets/dictionary/temas/videos/mãe.ogv")
	videos[4].get_node("Panel").get_child(1).play()
	videos[5].add_to_group("enemies")
	videos[5].get_node("Panel").get_child(1).stream = load("res://assets/dictionary/temas/videos/avó.ogv")
	videos[5].get_node("Panel").get_child(1).play()

	#for i in range(2,4):
		#videos_to_play.append(videos[i])

func play_videos() -> void:
	for video in videos_to_play:
		video.get_node("Panel").get_child(1).play()
