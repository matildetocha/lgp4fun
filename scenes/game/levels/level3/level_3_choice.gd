extends Node2D

var level_3_scene: PackedScene = preload("res://scenes/game/levels/level3/level_3.tscn")
var level_3_stats_scene: PackedScene = preload("res://scenes/game/levels/level3/level3_stats.tscn")
var game_over_scene: PackedScene = preload("res://scenes/game/levels/game_over.tscn")

var level_3: Node2D
var level_3_stats: Node2D
var game_over: Node2D

@export var theme = "(1ºCEB)"
@export 	var valid_themes = [
		"(1ºCEB) CASA E DIVISÕES"]
		
var themes_fetched = []
var selected_theme = ""

@onready var menu_button: MenuButton = $TextureRect/MenuButton
var console = JavaScriptBridge.get_interface("console")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Supabase.database.connect("selected", _on_themes_fetched)
	Supabase.database.connect("error", _on_supabase_error)
	
	var q = SupabaseQuery.new().from("signs_themes").select().like("theme", theme.uri_encode())
	
	Supabase.database.query(q)
	
	level_3 = level_3_scene.instantiate()
	level_3.connect("go_back", go_back)
	level_3.connect("show_level_stats", level_stats)
	
	GameManager.connect("game_over", game_over_level1)

func get_theme() -> String:
	return selected_theme

func _on_themes_fetched(themes: Array) -> void:
	for t in themes:
		themes_fetched.append(t)
		
		if t["theme"] in valid_themes:
			menu_button.get_popup().add_item(t["theme"])
			

func _on_supabase_error(err: SupabaseDatabaseError) -> void:
	var msg := err.to_string()  
	push_error("Supabase returned an error: %s" % msg)

func _on_menu_button_about_to_popup() -> void:
	menu_button.get_popup().connect("index_pressed", _on_theme_selected)
	
func _on_theme_selected(index: int):
	selected_theme = menu_button.get_popup().get_item_text(index)
	add_child(level_3)

func level_stats() -> void:
	await get_tree().create_timer(0.5).timeout
	
	level_3.queue_free()
	
	level_3_stats = level_3_stats_scene.instantiate()
	add_child(level_3_stats)
	
	level_3_stats.connect("end_stats", end_level)

func game_over_level1() -> void:
	await get_tree().create_timer(0.5).timeout
	
	level_3.queue_free()
	
	game_over = game_over_scene.instantiate()
	add_child(game_over)
	
	game_over.connect("end_game_over", end_level)
	
func end_stats() -> void:
	level_3_stats.queue_free()
	end_level()

func end_game_over() -> void:
	game_over.queue_free()
	end_level()
	
func go_back() -> void:
	end_level()
	
func end_level() -> void:
	GameManager.reset()
	queue_free()
