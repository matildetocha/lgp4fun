extends Node2D

signal end_game_over

func _on_game_over_button_pressed() -> void:
	end_game_over.emit()
