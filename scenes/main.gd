extends Control

@onready var scene_transition: AnimationPlayer = $SceneTransition/AnimationPlayer
@export var game_scene: PackedScene
var game_world: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cache_path = "user://cache/"
	var image_cache_path = "user://cache/images"
	var video_cache_path = "user://cache/videos"

	if !DirAccess.dir_exists_absolute(cache_path):
		DirAccess.make_dir_absolute(cache_path)
		DirAccess.make_dir_absolute(image_cache_path)
		DirAccess.make_dir_absolute(video_cache_path)

	if !DirAccess.dir_exists_absolute(image_cache_path):
		DirAccess.make_dir_absolute(image_cache_path)

	if !DirAccess.dir_exists_absolute(video_cache_path):
		DirAccess.make_dir_absolute(video_cache_path)
	
func _on_start_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	
	game_world = game_scene.instantiate()
	add_child(game_world)
	game_world.connect("goto_main", goto_main)
	
func goto_main() -> void:
	game_world.queue_free()
