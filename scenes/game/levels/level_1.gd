extends Node

signal show_level_stats
signal go_back

@onready var scene_transition: AnimationPlayer = $SceneTransition/AnimationPlayer
@onready var end: Node2D = $Collectables/End

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_transition.get_parent().get_node("ColorRect").color.a = 255
	scene_transition.play("fade_out")
	end.connect("end_game", end_level_1)

func end_level_1() -> void:
	show_level_stats.emit()

func _on_back_button_pressed() -> void:
	go_back.emit()
