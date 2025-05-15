extends Node2D

@export var start_scene: PackedScene
var current_level: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level = start_scene.instantiate()
	$Levels.add_child(current_level)
	current_level.connect("goto_main", goto_main)

func goto_main() -> void:
	queue_free()
