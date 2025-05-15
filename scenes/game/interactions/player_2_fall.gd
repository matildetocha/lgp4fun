extends Area2D

@onready var checkpoint_manager = $".."
@onready var player_2: CharacterBody2D = $"../../Players/Player2"

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player2"):
		GameManager.reduce_health()
		
		player_2.position = checkpoint_manager.last_location_p2
