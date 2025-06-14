extends Node2D

signal game_over

# Collectables
var big_points = 0
var small_points = 0
var sign_points = 0

# Health
const MAX_HEALTH = 5
var health = MAX_HEALTH

# Level vars
var level1_letter: String
var level2_theme: String
var level2_stats = []
var level3_stats = []

var console = JavaScriptBridge.get_interface("console")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	pass

func get_level1_letter() -> String:
	return level1_letter
	
func set_level1_letter(letter: String) -> void:
	level1_letter = letter

func set_level2_stats(stats) -> void:
	level2_stats = stats

func set_level3_stats(learned, all) -> void:
	level3_stats = [learned, all]
	
func get_big_points() -> int:
	return big_points

func get_small_points() -> int:
	return small_points

func get_sign_points() -> int:
	return sign_points

func get_health() -> int:
	return health
	
func add_big_point() -> void:
	big_points += 1

func add_small_point() -> void:
	small_points += 1

func add_sign_point() -> void:
	sign_points += 1
	
func reduce_health() -> void:
	if (health - 1 >= 0):
		health -= 1
		
	if (health == 0):
		game_over.emit()

func add_health() -> void:
	if (health + 1 <= MAX_HEALTH):
		health += 1
	
func reset() -> void:
	big_points = 0
	small_points = 0
	sign_points = 0
	health = MAX_HEALTH
	level1_letter = ""
