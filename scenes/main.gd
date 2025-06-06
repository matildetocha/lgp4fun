extends Control

@onready var scene_transition: AnimationPlayer = $SceneTransition/AnimationPlayer
@export var game_scene: PackedScene
var game_world: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Supabase.database.connect("selected", _on_signs_selected)
	Supabase.database.connect("error", _on_supabase_error)
	
	var theme = "(1ºCEB) PARTES DA CASA"
	var q = SupabaseQuery.new().from("signs").select().eq("theme_flattened", theme.uri_encode())
		
	Supabase.database.query(q)
	#print("Request sent")

func _on_signs_selected(rows: Array) -> void:
	pass
	#print("Fetched %d rows from 'signs':" % rows.size())
	#for r in rows:
		#print(r["name"])

func _on_supabase_error(err: SupabaseDatabaseError) -> void:
	var msg := err.to_string()  
	#push_error("Supabase returned an error: %s" % msg)

func _on_start_pressed() -> void:
	scene_transition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	
	game_world = game_scene.instantiate()
	add_child(game_world)
	game_world.connect("goto_main", goto_main)
	
func goto_main() -> void:
	game_world.queue_free()
