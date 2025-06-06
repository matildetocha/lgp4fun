extends Node2D

signal goto_main

@export var level_1: PackedScene
@export var level_2: PackedScene
var current_level: Node

var game_over_scene: PackedScene = preload("res://scenes/game/levels/game_over.tscn")
var game_over: Node2D

var level_2_stats_scene: PackedScene = preload("res://scenes/game/levels/level2/level2_stats.tscn")
var level_2_stats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_level_1_button_pressed() -> void:
	current_level = level_1.instantiate()
	$Levels.add_child(current_level)

func _on_level_2_button_pressed() -> void:
	current_level = level_2.instantiate()
	$Levels.add_child(current_level)
	current_level.connect("go_back", goto_levels)
	current_level.connect("level2_over", goto_game_over)
	current_level.connect("show_level_stats", level_stats)

func goto_levels() -> void:
	GameManager.reset()
	current_level.queue_free()

func goto_game_over() -> void:
	await get_tree().create_timer(0.5).timeout
	
	current_level.queue_free()
	game_over = game_over_scene.instantiate()
	add_child(game_over)
	
	game_over.connect("end_game_over", goto_start)
	
func level_stats() -> void:
	await get_tree().create_timer(0.5).timeout
	
	current_level.queue_free()
	
	level_2_stats = level_2_stats_scene.instantiate()
	add_child(level_2_stats)
	
	level_2_stats.connect("end_stats", goto_start)
	
func goto_start() -> void:
	GameManager.reset()
	goto_main.emit()
	
func _on_back_button_pressed() -> void:
	GameManager.reset()
	goto_main.emit()
