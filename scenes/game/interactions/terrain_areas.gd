extends Node2D

signal next_vocab_level
signal play_video

# Players
@onready var player_1: CharacterBody2D = $"../Player1"
@onready var player_2: CharacterBody2D = $"../Player2"

# Last Locations
var last_location_p1
var last_location_p2

# Vocab Level
var current_vocab_level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_location_p1 = player_1.global_position
	last_location_p2 = player_2.global_position
	
func next_vocab() -> void:
	next_vocab_level.emit()
	play_video.emit(current_vocab_level)
