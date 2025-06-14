extends Control

@onready var scene_transition: AnimationPlayer = $SceneTransition/AnimationPlayer
@export var game_scene: PackedScene
var game_world: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_start_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	
	game_world = game_scene.instantiate()
	add_child(game_world)
	game_world.connect("goto_main", goto_main)
	
func goto_main() -> void:
	game_world.queue_free()
