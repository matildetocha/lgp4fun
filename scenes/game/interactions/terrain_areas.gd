extends Node2D

# Players
@onready var player_1: CharacterBody2D = $"../Players/Player1"
@onready var player_2: CharacterBody2D = $"../Players/Player2"

# Last Locations
var last_location_p1
var last_location_p2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_location_p1 = player_1.global_position
	last_location_p2 = player_2.global_position
