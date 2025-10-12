extends Node2D

signal populate
signal go_back
signal show_level_stats
signal timeout
signal docker_ffmpeg_done(exit_code: int, output: String)

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
const IMAGE_CACHE_PATH = "user://cache/images"
const VIDEO_CACHE_PATH = "user://cache/videos"

var current_word = []
var counter = 1
var vocab_words = []
var vocab_learned = []

@onready var level2_man = $".."

@onready var collectables: Node2D = $Collectables
@onready var end: Node2D = $Collectables/End
@onready var terrain_areas: Node2D = $TerrainAreas

@onready var scene_transition: AnimationPlayer = $SceneTransition/AnimationPlayer
@onready var image_http_request: AwaitableHTTPRequest = $ImageHTTPRequest
@onready var video_http_request: AwaitableHTTPRequest = $VideoHTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_transition.get_parent().get_node("ColorRect").color.a = 255
	scene_transition.play("fade_out")
	
	loading_screen = loading_scene.instantiate()
	add_child(loading_screen)
	
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
		var video_file = s["name"].to_lower() + ".ogv"
		var video_path = VIDEO_CACHE_PATH + "/" + video_file
		var video_dir = DirAccess.open(VIDEO_CACHE_PATH)
		
		if (s["game_video"]):
				if video_file not in video_dir.get_files():
						video_http_request.download_file = video_path
						await video_http_request.async_request(s["game_video"])
				vocab.append(video_path)
		
		# else:
		# 		var temp_mp4 = VIDEO_CACHE_PATH + "/" + s["name"].to_lower() + ".mp4"
		# 		var ogv_path = temp_mp4.replace(".mp4", ".ogv")
		# 		var temp_mp4_abs = ProjectSettings.globalize_path(temp_mp4)
		# 		var ogv_path_abs = ProjectSettings.globalize_path(ogv_path)
				
		# 		video_http_request.download_file = temp_mp4
		# 		await video_http_request.async_request(s["video"])
				
		# 		# Use the cache dir as the mount point and refer to files as /work/<name> inside the container
		# 		var work_dir_abs = ProjectSettings.globalize_path(VIDEO_CACHE_PATH)
		# 		var in_name = temp_mp4.get_file()
		# 		var out_name = ogv_path.get_file()

		# 		# Run docker/ffmpeg asynchronously to avoid blocking the main thread
		# 		var exit_code := await _run_docker_ffmpeg_async(work_dir_abs, in_name, out_name)
		# 		if exit_code != 0:
		# 			push_error("docker/ffmpeg failed converting %s -> %s" % [in_name, out_name])
		# 		else:
		# 			video_dir.remove(temp_mp4.get_file())

				# Upload to Supabase Storage
				# var bucket_name = "lgp4fun"

				# var upload_task : StorageTask = await Supabase.storage.from(bucket_name).upload(video_file, VIDEO_CACHE_PATH).completed
				# print("Upload data: ", upload_task.data, " || error: ", upload_task.error)

				# # Get public URL for the uploaded video
				# var public_url = Supabase.storage.from(bucket_name).get_public_url(video_file)
				# #var public_url = public_url_task.data.url if public_url_task.data.has("url") else ""
				# print("Public URL: ", public_url)
				
				# # Update s["game_video"] in your database
				# var update_query = SupabaseQuery.new().from("signs").update({ "game_video": public_url }).eq("name", s["name"])
				# Supabase.database.query(update_query)
				
				# vocab.append(ogv_path)
			
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

# --- Async docker helpers ---

func _run_docker_ffmpeg_async(work_dir_abs: String, in_name: String, out_name: String) -> int:
	var ffmpeg_args := PackedStringArray([
		"run", "--rm",
		"-v", work_dir_abs + ":/work",
		"-w", "/work",
		"lscr.io/linuxserver/ffmpeg:latest",
		"-y",
		"-i", "/work/" + in_name,
		"-c:v", "libtheora", "-q:v", "5",
		"/work/" + out_name
	])

	var thread := Thread.new()
	thread.start(Callable(self, "_docker_ffmpeg_thread").bind(ffmpeg_args))

	var result = await docker_ffmpeg_done
	thread.wait_to_finish()
	return int(result[0])

func _docker_ffmpeg_thread(ffmpeg_args: PackedStringArray) -> void:
	var output := []
	var code := OS.execute("/usr/local/bin/docker", ffmpeg_args, output, true)
	# emit back on main thread
	call_deferred("_emit_docker_ffmpeg_done", code, "\n".join(output))

func _emit_docker_ffmpeg_done(code: int, out: String) -> void:
	docker_ffmpeg_done.emit(code, out)
