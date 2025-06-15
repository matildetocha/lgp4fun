extends Control

@onready var scene_transition: AnimationPlayer = $SceneTransition/AnimationPlayer
@export var game_scene: PackedScene
var game_world: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cache_path = "user://cache/"
	if DirAccess.dir_exists_absolute(cache_path):
		var dir = DirAccess.open(cache_path)
		for file in dir.get_files():
			dir.remove(file)
	else:
		DirAccess.make_dir_absolute(cache_path)
	

func _on_start_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	
	game_world = game_scene.instantiate()
	add_child(game_world)
	game_world.connect("goto_main", goto_main)
	
func goto_main() -> void:
	game_world.queue_free()
