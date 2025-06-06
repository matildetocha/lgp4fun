extends Area2D

@onready var checkpoint_manager = $".."
@onready var player_1: CharacterBody2D = $"../../Player1"

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player1"):
		GameManager.reduce_health()
		
		player_1.position = checkpoint_manager.last_location_p1
