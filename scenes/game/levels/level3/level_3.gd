extends Node2D

signal populate
signal assemble
signal go_back
signal show_level_stats

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
@onready var http_request: AwaitableHTTPRequest = $AwaitableHTTPRequest

const MAX_VOCAB = 5
const VIDEO_PATH = "res://assets/dictionary/temas/videos/"

var current_word = ""

var vocab_words = []
var vocab_challenge = []
var vocab_learned = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_transition.get_parent().get_node("ColorRect").color.a = 255
	scene_transition.play("fade_out")
	
	Supabase.database.connect("selected", _on_signs_fetched)
	Supabase.database.connect("error", _on_supabase_error)
	
	var theme = level3_man.get_theme()
	
	var q = SupabaseQuery.new().from("signs").select().eq("theme_flattened", theme.uri_encode())
	Supabase.database.query(q)
	
	end.connect("end_game", end_level_3)
	terrain_areas.connect("next_vocab_level", reset_word)	

func _on_signs_fetched(signs: Array) -> void:
	var amount_to_pick = min(MAX_VOCAB, signs.size())

	randomize()
	signs.shuffle()  # Shuffle the array to randomize order

	for i in range(amount_to_pick):
		vocab_words.append(signs[i])
	
	for v in vocab_words:
		var temp = remove_random_syllable(v["name"])
		vocab_challenge.append(temp)
	
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
		
	if (current_word["image"]):
		var resp = await http_request.async_request(current_word["image"])
		var img = Image.new()
		var err = img.load_png_from_buffer(resp.bytes)
		if resp.success():
			if err == OK:
				var texture = ImageTexture.create_from_image(img)
				image.texture = texture
				image.visible = true
				middle_color_rect.visible = false

	video.stream = load(VIDEO_PATH + current_word["name"].to_lower() + ".ogv")
	video.play()
	left_color_rect.visible = false
	
	word.text = vocab_challenge[terrain_areas.current_vocab_level][0]
	right_color_rect.visible = false
	
func add_vocab(new_word: String) -> void:
	vocab_learned.append(new_word)

func vocab_assembly() -> void:
	word.text = current_word["name"].to_lower()
	assemble.emit(true)

func reset_word() -> void:	
	await get_tree().create_timer(1.5).timeout
	
	video.stop()
	left_color_rect.visible = true
	
	image.visible = false
	middle_color_rect.visible = true
	
	word.text = ""
	right_color_rect.visible = true
	
	assemble.emit(false)
	
	if (terrain_areas.current_vocab_level < MAX_VOCAB):
		set_current_word()
