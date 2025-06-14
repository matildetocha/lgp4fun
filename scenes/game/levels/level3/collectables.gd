extends Node2D

@onready var words_node: Node2D = $Words
@onready var level3 = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level3.connect("populate", populate_collectables)

func populate_collectables() -> void:
	var words = words_node.get_children()
	randomize()
	
	if (level3.vocab_challenge.size() > 0):
		for i in range(5):
			var correct_syllable = level3.vocab_challenge[i][1]
			var pair_index = i * 2

			if i == 0:
				# First pair: both show the correct syllable
				words[pair_index].get_child(0).text = correct_syllable
				words[pair_index].add_to_group("collectables")
				
				words[pair_index + 1].get_child(0).text = correct_syllable
				words[pair_index + 1].add_to_group("collectables")
				
			else:
				# Get incorrect syllables that are different from the correct one
				var possible_incorrects = level3.SILABAS_COMUNS.duplicate()
				possible_incorrects.erase(correct_syllable)

				# Choose a random incorrect syllable
				var incorrect_syllable = possible_incorrects[randi() % possible_incorrects.size()]

				# Randomize placement
				var place_correct_on_left = randi() % 2 == 0

				if place_correct_on_left:
					words[pair_index].get_child(0).text = correct_syllable
					words[pair_index].add_to_group("collectables")
					
					words[pair_index + 1].get_child(0).text = incorrect_syllable
					words[pair_index + 1].add_to_group("enemies")
					
				else:
					words[pair_index].get_child(0).text = incorrect_syllable
					words[pair_index].add_to_group("enemies")
					
					words[pair_index + 1].get_child(0).text = correct_syllable
					words[pair_index + 1].add_to_group("collectables")
