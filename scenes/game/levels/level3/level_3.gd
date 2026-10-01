extends Node2D

signal populate
signal assemble
signal go_back
signal show_level_stats
signal timeout

const SILABAS_COMUNS = [
		"a", "e", "i", "o", "u",
		"ba","be","bi","bo","bu",
		"ca","ce","ci","co","cu",
		"da","de","di","do","du",
		"fa","fe","fi","fo","fu",
		"ga","ge","gi","go","gu",
		"ja", "jo", "ju",
		"la","le","li","lo","lu",
		"ma","me","mi","mo","mu",
		"na","ne","ni","no","nu",
		"pa","pe","pi","po","pu",
		"qua", "que", "qui", 
		"ra","re","ri","ro","ru",
		"rra", "rre", "rri", "rro", "rru",
		"sa","se","si","so","su",
		"ssa", "sse", "ssi", "sso", "ssu",
		"ta","te","ti","to","tu",
		"va","ve","vi","vo","vu",
		"xa", "xe", "xi", "xo", "xu",
		"ai","ei","eu","oi","ou",
		"ão","ãe","õe",
		"lha", "lhe", "lhi", "lho", "lhu",
		"cha", "che", "chi", "cho", "chu",
		"nha", "nhe", "nhi", "nho", "nhu"
	]

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

@onready var level3_man = $".."
@onready var collectables: Node2D = $Collectables
@onready var end: Node2D = $Collectables/End
@onready var terrain_areas: Node2D = $TerrainAreas

@onready var scene_transition: AnimationPlayer = $SceneTransition/AnimationPlayer
@onready var image_http_request: AwaitableHTTPRequest = $ImageHTTPRequest
@onready var video_http_request: AwaitableHTTPRequest = $VideoHTTPRequest

const MAX_VOCAB = 5
const IMAGE_CACHE_PATH = "user://cache/images"
const VIDEO_CACHE_PATH = "user://cache/videos"
const VIDEO_PATH = "res://assets/dictionary/temas/videos/"

var current_word = ""

var vocab_words = []
var vocab_challenge = []
var vocab_learned = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_transition.get_parent().get_node("ColorRect").color.a = 255
	scene_transition.play("fade_out")
	
	loading_screen = loading_scene.instantiate()
	add_child(loading_screen)
	
	Supabase.database.connect("selected", _on_signs_fetched)
	Supabase.database.connect("error", _on_supabase_error)
	
	var theme = level3_man.get_theme()
	
	var q = SupabaseQuery.new().from("signs").select().contains("dictionary", ["1º CEB"]).eq("theme_flattened", theme.uri_encode())
	Supabase.database.query(q)
	
	end.connect("end_game", end_level_3)
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
		
		var challenge = remove_random_syllable(s["name"])
		vocab.append(challenge)
		
		# Image handling
		if (s["image"]):
			var file = s["name"].to_lower() + ".png"
			var image_path = IMAGE_CACHE_PATH + "/" + file
			var dir = DirAccess.open(IMAGE_CACHE_PATH)
			
			if file in dir.get_files():
					var img = Image.new()
					var err = img.load(image_path)
					if err == OK:
							var texture = ImageTexture.create_from_image(img)
							vocab.append(texture)
			else:
					var resp = await image_http_request.async_request(s["image"])
					var img = Image.new()
					var err = img.load_png_from_buffer(resp.bytes)
					if resp.success():
							if err == OK:
									# Save image to cache
									img.save_png(image_path)
									var texture = ImageTexture.create_from_image(img)
									vocab.append(texture)
		
		# Video handling		
		if (s["game_video"]):
			var file = s["name"].to_lower() + ".ogv"
			var video_path = VIDEO_CACHE_PATH + "/" + file
			var dir = DirAccess.open(VIDEO_CACHE_PATH)
			
			if file not in dir.get_files():
					video_http_request.download_file = video_path
					await video_http_request.async_request(s["game_video"])
					
			vocab.append(video_path)
			
		vocab_words.append(vocab)
	
	loading_screen.queue_free()
	$Timer.start()
	populate.emit()
	set_current_word()

func _on_supabase_error(err: SupabaseDatabaseError) -> void:
	var msg := err.to_string()  
	push_error("Supabase returned an error: %s" % msg)

func _on_back_button_pressed() -> void:
	go_back.emit()

func end_level_3() -> void:
	GameManager.set_level3_stats(vocab_learned, vocab_words)
	show_level_stats.emit()		
	
func remove_random_syllable(text: String) -> Array:
	var word_lower = text.to_lower()
	var word_syllables = []

	for s in SILABAS_COMUNS:
		if word_lower.find(s) >= 0:
			word_syllables.append(s)

	randomize()
	var chosen_syllable = word_syllables[randi() % word_syllables.size()]

	var sub = ""
	for i in chosen_syllable:
		sub += "_"

	var new_word = ""
	var i = 0
	while i < word_lower.length():
		if word_lower.substr(i, chosen_syllable.length()).to_lower() == chosen_syllable:
			new_word += sub
			i += chosen_syllable.length()
		else:
			new_word += word_lower[i]
			i += 1

	return [new_word, chosen_syllable]

func set_current_word() -> void:
	current_word = vocab_words[terrain_areas.current_vocab_level]
	
	image.texture = current_word[2]
	image.visible = true
	middle_color_rect.visible = false
				
	video.stream = load(current_word[3])
	video.play()
	left_color_rect.visible = false
	
	word.text = current_word[1][0]
	right_color_rect.visible = false
	
func add_vocab(new_word: String) -> void:
	vocab_learned.append(new_word)

func vocab_assembly() -> void:
	word.text = current_word[0].to_lower()
	assemble.emit(true)

func reset_word() -> void:		
	video.stop()
	left_color_rect.visible = true
	
	image.visible = false
	middle_color_rect.visible = true
	
	word.text = ""
	right_color_rect.visible = true
	
	assemble.emit(false)
	
	if (terrain_areas.current_vocab_level < MAX_VOCAB):
		set_current_word()

func _on_timer_timeout() -> void:
	timeout.emit()
