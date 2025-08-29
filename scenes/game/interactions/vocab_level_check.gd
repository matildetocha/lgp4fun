extends Area2D

@onready var vocab_check_manager: Node2D = $"../.."

var players_in_checkpoint := {}

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player1" || body.name == "Player2"):
		players_in_checkpoint[body.name] = true
		
		if players_in_checkpoint.has("Player1") and players_in_checkpoint.has("Player2"):
			vocab_check_manager.current_vocab_level += 1
			vocab_check_manager.next_vocab()
				
			queue_free()
	
