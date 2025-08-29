extends Node2D

@export var level_0_scene: PackedScene 
@export var level_0_stats_scene: PackedScene
@export var game_over_scene: PackedScene

var level_0: Node2D
var level_0_stats: Node2D
var game_over: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_0 = level_0_scene.instantiate()
	level_0.connect("show_level_stats", level_stats)
	level_0.connect("go_back", go_back)
	level_0.connect("timeout", game_over_level0)
	
	GameManager.connect("game_over", game_over_level0)

func _on_button_a_pressed() -> void:
	GameManager.set_level1_letter("a")
		
	add_child(level_0)

func _on_button_b_pressed() -> void:
	GameManager.set_level1_letter("b")
	
	add_child(level_0)

func _on_button_c_pressed() -> void:
	GameManager.set_level1_letter("c")
	
	add_child(level_0)

func _on_button_d_pressed() -> void:
	GameManager.set_level1_letter("d")
	
	add_child(level_0)

func _on_button_e_pressed() -> void:
	GameManager.set_level1_letter("e")
	
	add_child(level_0)

func _on_button_f_pressed() -> void:
	GameManager.set_level1_letter("f")
	
	add_child(level_0)

func _on_button_g_pressed() -> void:
	GameManager.set_level1_letter("g")
	
	add_child(level_0)

func _on_button_h_pressed() -> void:
	GameManager.set_level1_letter("h")
	
	add_child(level_0)

func _on_button_i_pressed() -> void:
	GameManager.set_level1_letter("i")

	add_child(level_0)

func _on_button_j_pressed() -> void:
	GameManager.set_level1_letter("j")

	add_child(level_0)

func _on_button_k_pressed() -> void:
	GameManager.set_level1_letter("k")

	add_child(level_0)

func _on_button_l_pressed() -> void:
	GameManager.set_level1_letter("l")

	add_child(level_0)

func _on_button_m_pressed() -> void:
	GameManager.set_level1_letter("m")

	add_child(level_0)

func _on_button_n_pressed() -> void:
	GameManager.set_level1_letter("n")

	add_child(level_0)

func _on_button_o_pressed() -> void:
	GameManager.set_level1_letter("o")

	add_child(level_0)

func _on_button_p_pressed() -> void:
	GameManager.set_level1_letter("p")

	add_child(level_0)

func _on_button_q_pressed() -> void:
	GameManager.set_level1_letter("q")

	add_child(level_0)

func _on_button_r_pressed() -> void:
	GameManager.set_level1_letter("r")

	add_child(level_0)

func _on_button_s_pressed() -> void:
	GameManager.set_level1_letter("s")

	add_child(level_0)

func _on_button_t_pressed() -> void:
	GameManager.set_level1_letter("t")

	add_child(level_0)

func _on_button_u_pressed() -> void:
	GameManager.set_level1_letter("u")

	add_child(level_0)

func _on_button_v_pressed() -> void:
	GameManager.set_level1_letter("v")

	add_child(level_0)

func _on_button_w_pressed() -> void:
	GameManager.set_level1_letter("w")

	add_child(level_0)

func _on_button_y_pressed() -> void:
	GameManager.set_level1_letter("y")

	add_child(level_0)

func _on_button_z_pressed() -> void:
	GameManager.set_level1_letter("z")
	
	add_child(level_0)

func level_stats() -> void:
	await get_tree().create_timer(0.5).timeout
	
	level_0.queue_free()
	
	level_0_stats = level_0_stats_scene.instantiate()
	add_child(level_0_stats)
	
	level_0_stats.connect("end_stats", end_level)

func game_over_level0() -> void:
	await get_tree().create_timer(0.5).timeout
	
	level_0.queue_free()
	
	game_over = game_over_scene.instantiate()
	add_child(game_over)
	
	game_over.connect("end_game_over", end_level)
	
func end_stats() -> void:
	level_0_stats.queue_free()
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
