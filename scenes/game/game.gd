extends Node2D

signal goto_main

@export var level_0: PackedScene
@export var level_1: PackedScene
@export var level_2: PackedScene
@export var level_3: PackedScene

var current_level: Node

var game_over_scene: PackedScene = preload("res://scenes/game/levels/game_over.tscn")
var game_over: Node2D

var level_2_stats_scene: PackedScene = preload("res://scenes/game/levels/level2/level2_stats.tscn")
var level_2_stats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_level_0_button_pressed() -> void:
	current_level = level_0.instantiate()
	$Levels.add_child(current_level)
	
func _on_level_1_button_pressed() -> void:
	current_level = level_1.instantiate()
	$Levels.add_child(current_level)

func _on_level_2_button_pressed() -> void:
	current_level = level_2.instantiate()
	$Levels.add_child(current_level)

func _on_level_3_button_pressed() -> void:
	current_level = level_3.instantiate()
	$Levels.add_child(current_level)
	
func goto_start() -> void:
	GameManager.reset()
	goto_main.emit()
	
func _on_back_button_pressed() -> void:
	GameManager.reset()
	goto_main.emit()
