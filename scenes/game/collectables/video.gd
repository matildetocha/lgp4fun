extends Area2D

@onready var video: VideoStreamPlayer = $Panel/Video
@onready var effects: AnimationPlayer = $Effects
@onready var level2_man = $"../../.."

const PATH = "res://assets/dictionary/temas/videos/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	effects.play("blink")

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player1" || body.name == "Player2"):
		queue_free()
		if (level2_man.get_current_word()):	
			if (video.stream.resource_path == PATH + level2_man.get_current_word() + ".ogv"):
				level2_man.vocab_assembly("video")
				GameManager.add_big_point()
				GameManager.add_health()
				
			else:
				GameManager.reduce_health()
