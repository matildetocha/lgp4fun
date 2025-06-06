extends Area2D

@onready var vocab_check_manager: Node2D = $"../.."

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player1" || body.name == "Player2"):
		vocab_check_manager.current_vocab_level += 1
		print(vocab_check_manager.current_vocab_level)
		vocab_check_manager.next_vocab()
		queue_free()
	
