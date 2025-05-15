extends Camera2D

@onready var player_1: CharacterBody2D = $"../Players/Player1"
@onready var player_2: CharacterBody2D = $"../Players/Player2"

# Camera limits
const LEFT = 0
const RIGHT = 18480
const TOP = 0
const BOTTOM = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.global_position = (player_1.global_position + player_2.global_position) * 0.5
	
