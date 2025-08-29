extends Node2D

@export var level_2_scene: PackedScene
@export var level_2_stats_scene: PackedScene
@export var game_over_scene: PackedScene

var level_2: Node2D
var level_2_stats: Node2D
var game_over: Node2D

@export var theme = "(1ºCEB)"
@export var valid_themes = [
		"(1ºCEB) CASA E DIVISÕES",
		"(1ºCEB) OBJETOS DA ESCOLA",
		"(1ºCEB) CORES/ PORTUGUÊS"]
		
var themes_fetched = []
var selected_theme = ""

var console = JavaScriptBridge.get_interface("console")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Supabase.database.connect("selected", _on_themes_fetched)
	#Supabase.database.connect("error", _on_supabase_error)
	
	#var q = SupabaseQuery.new().from("signs_themes").select().like("theme", theme.uri_encode())
	
	#Supabase.database.query(q)
	
	level_2 = level_2_scene.instantiate()
	level_2.connect("go_back", go_back)
	level_2.connect("show_level_stats", level_stats)
	level_2.connect("timeout", game_over_level2)
	
	GameManager.connect("game_over", game_over_level2)

func get_theme() -> String:
	return selected_theme

func _on_themes_fetched(themes: Array) -> void:
	for t in themes:
		themes_fetched.append(t)		

func _on_supabase_error(err: SupabaseDatabaseError) -> void:
	var msg := err.to_string()  
	push_error("Supabase returned an error: %s" % msg)

func _on_button_1_pressed() -> void:
	selected_theme = "(1ºCEB) CASA E DIVISÕES"
	add_child(level_2)

func _on_button_2_pressed() -> void:
	selected_theme = "(1ºCEB) OBJETOS DA ESCOLA"
	add_child(level_2)

func _on_button_3_pressed() -> void:
	selected_theme = "(1ºCEB) CORES/ PORTUGUÊS"
	add_child(level_2)
	
func level_stats() -> void:
	await get_tree().create_timer(0.5).timeout
	
	level_2.queue_free()
	
	level_2_stats = level_2_stats_scene.instantiate()
	add_child(level_2_stats)
	
	level_2_stats.connect("end_stats", end_level)

func game_over_level2() -> void:
	await get_tree().create_timer(0.5).timeout
	
	level_2.queue_free()
	
	game_over = game_over_scene.instantiate()
	add_child(game_over)
	
	game_over.connect("end_game_over", end_level)
	
func end_stats() -> void:
	level_2_stats.queue_free()
	end_level()

func end_game_over() -> void:
	game_over.queue_free()
	end_level()
	
func go_back() -> void:
	end_level()

func _on_back_button_pressed() -> void:
	end_level()
	
func end_level() -> void:
	GameManager.reset()
	queue_free()
