extends Node2D

@onready var big_letter: Node2D = $BigLetter
@onready var sign_letter: Node2D = $SignLetter

@onready var level_letter = GameManager.get_level1_letter()
var alphabet = "abcdefghijklmnopqrstuvwyz"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	alphabet = alphabet.replace(level_letter, "")
	randomize()
	populate_collectables()

func populate_collectables() -> void:
	var big_letters = big_letter.get_children()
	var sign_letters = sign_letter.get_children()
	
	var big_index = randi() % big_letters.size() 
	var sign_index = randi() % sign_letters.size()
	
	# Populate Big Letters
	for i in big_letters.size():
		if i == big_index:
			big_letters[i].add_to_group("enemies")
			big_letters[i].get_child(0).text = random_letter().to_upper()
		else:
			big_letters[i].add_to_group("collectables")
			big_letters[i].get_child(0).text = level_letter.to_upper()
		
	# Populate Sign Letters
	for i in sign_letters.size():
		if i == sign_index:
			sign_letters[i].add_to_group("enemies")
			sign_letters[i].get_node("Panel").get_child(2).texture = load("res://assets/dictionary/configuration/" + random_letter().to_upper() + ".svg") 
		else:
			sign_letters[i].add_to_group("collectables")
			sign_letters[i].get_node("Panel").get_child(2).texture = load("res://assets/dictionary/configuration/" + level_letter.to_upper() + ".svg") 
	
func random_letter() -> String:
	var index = randi() % alphabet.length()
	return alphabet[index]
