extends Area2D

@onready var checkpoint_manager: Node2D = $"../.."

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player1"):
		checkpoint_manager.last_location_p1 = $RespawnPoint.global_position
	
	elif (body.name == "Player2"):
		checkpoint_manager.last_location_p2 = $RespawnPoint.global_position
	
