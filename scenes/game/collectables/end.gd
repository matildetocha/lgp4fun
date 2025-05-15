extends Node2D

signal end_game

var gems_catched = 0 
@onready var end_player_1: Area2D = $EndPlayer1
@onready var end_player_2: Area2D = $EndPlayer2

func _on_end_player_1_body_entered(body: Node2D) -> void:
	if (body.name == "Player1"):
		gems_catched += 1
		if (gems_catched == 2):
			end_game.emit()
		end_player_1.queue_free()

func _on_end_player_2_body_entered(body: Node2D) -> void:
	if (body.name == "Player2"):
		gems_catched += 1
		if (gems_catched == 2):
			end_game.emit()
		end_player_2.queue_free()
