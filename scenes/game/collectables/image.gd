extends Area2D

@onready var image: TextureRect = $Panel/Image
@onready var effects: AnimationPlayer = $Effects
@onready var level2_man = $"../../.."
@onready var collectables = $"../.."

const PATH = "res://assets/dictionary/temas/images/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	effects.play("blink")

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player1" || body.name == "Player2"):
		queue_free()
			
		if (level2_man.current_word):	
			if (image.texture.resource_path == PATH + level2_man.current_word + ".png"):
				level2_man.vocab_assembly("image")
				GameManager.add_big_point()
				GameManager.add_health()
				
			else:
				GameManager.reduce_health()
