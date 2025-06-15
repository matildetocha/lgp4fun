extends Node2D

signal populate
signal go_back
signal show_level_stats
signal timeout

@export var loading_scene: PackedScene
var loading_screen: CanvasLayer

# Left Puzzle
@onready var video: VideoStreamPlayer = $UI/VocabControl/HBoxContainer/Left/VideoStreamPlayer
@onready var left_color_rect: ColorRect = $UI/VocabControl/HBoxContainer/Left/ColorRect

# Middle Puzzle
@onready var image: TextureRect = $UI/VocabControl/HBoxContainer/Middle/TextureRect
@onready var middle_color_rect: ColorRect = $UI/VocabControl/HBoxContainer/Middle/ColorRect

# Right Puzzle
@onready var word: Label = $UI/VocabControl/HBoxContainer/Right/Label
@onready var right_color_rect: ColorRect = $UI/VocabControl/HBoxContainer/Right/ColorRect

const MAX_VOCAB = 5
const VIDEO_CACHE_PATH = "user://cache/"

var current_word = []
var counter = 1
var vocab_words = []
var vocab_learned = []

@onready var level2_man = $".."

@onready var collectables: Node2D = $Collectables
@onready var end: Node2D = $Collectables/End
@onready var terrain_areas: Node2D = $TerrainAreas

@onready var image_http_request: AwaitableHTTPRequest = $ImageHTTPRequest
@onready var video_http_request: AwaitableHTTPRequest = $VideoHTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loading_screen = loading_scene.instantiate()
	add_child(loading_screen)
	
	#scene_transition.get_parent().get_node("ColorRect").color.a = 255
	#scene_transition.play("fade_out")
	
	Supabase.database.connect("selected", _on_signs_fetched)
	Supabase.database.connect("error", _on_supabase_error)
	
	var theme = level2_man.get_theme()
	
	var q = SupabaseQuery.new().from("signs").select().eq("theme_flattened", theme.uri_encode())
	Supabase.database.query(q)
	
	end.connect("end_game", end_level_2)
	terrain_areas.connect("next_vocab_level", reset_word)	

func _on_signs_fetched(signs: Array) -> void:
	var amount_to_pick = min(MAX_VOCAB, signs.size())

	randomize()
	signs.shuffle()  # Shuffle the array to randomize order
	
	var level_signs = []
	for i in range(amount_to_pick):
		level_signs.append(signs[i])
	
	for s in level_signs:
		var vocab = []
		vocab.append(s["name"].to_lower())
		
		if (s["image"]):
			var resp = await image_http_request.async_request(s["image"])
			var img = Image.new()
			var err = img.load_png_from_buffer(resp.bytes)
			if resp.success():
				if err == OK:
					var texture = ImageTexture.create_from_image(img)
					vocab.append(texture)
		
		if (s["game_video"]):
			var file = s["name"].to_lower() + ".ogv"
			var dir = DirAccess.open(VIDEO_CACHE_PATH)
			
			if file not in dir.get_files():
				video_http_request.download_file = VIDEO_CACHE_PATH + file
				await video_http_request.async_request(s["game_video"])
				
			vocab.append(VIDEO_CACHE_PATH + file)
			
		vocab_words.append(vocab)
	
	loading_screen.queue_free()
	$Timer.start()
	populate.emit()
	set_current_word()
	vocab_tip()

func _on_supabase_error(err: SupabaseDatabaseError) -> void:
	var msg := err.to_string()  
	push_error("Supabase returned an error: %s" % msg)

func _on_back_button_pressed() -> void:
	go_back.emit()	

func end_level_2() -> void:
	GameManager.set_level2_stats(vocab_learned, vocab_words)
	show_level_stats.emit()		
	
func get_current_word() -> Array:
	return current_word
	
func set_current_word() -> void:
	current_word = vocab_words[terrain_areas.current_vocab_level]
	
func add_vocab(new_word: String) -> void:
	vocab_learned.append(new_word)

func add_counter() -> void:	
	if (counter <= 3):
		counter += 1
		
func vocab_assembly(type: String) -> void:
	if (type == "video"):
		video.stream = load(current_word[2])
		video.play()
		left_color_rect.visible = false
		
		add_counter()
		
	elif (type == "image"):
		image.texture = current_word[1]
		image.visible = true
		middle_color_rect.visible = false

		add_counter()
		
	elif (type == "word"):
		word.text = current_word[0]
		right_color_rect.visible = false
		
		add_counter()

func vocab_tip() -> void:
	match terrain_areas.current_vocab_level:
		0: 
			video.stream = load(current_word[2])
			video.play()
			left_color_rect.visible = false
		1:
			video.stream = load(current_word[2])
			video.play()
			left_color_rect.visible = false
		2:
			word.text = current_word[0]
			right_color_rect.visible = false
		3:
			image.texture = current_word[1]
			image.visible = true
			middle_color_rect.visible = false
		4:
			word.text = current_word[0]
			right_color_rect.visible = false
		_:
			pass
		
func reset_word() -> void:
	if (counter == 3):
		add_vocab(current_word[0])
	else:
		add_vocab("")
	await get_tree().create_timer(1.5).timeout
	
	video.stop()
	left_color_rect.visible = true
	
	image.visible = false
	middle_color_rect.visible = true
	
	word.text = ""
	right_color_rect.visible = true
	
	if (terrain_areas.current_vocab_level < MAX_VOCAB):
		set_current_word()
		vocab_tip()
		counter = 1
		
	else:
		counter = 0

func _on_timer_timeout() -> void:
	timeout.emit()
