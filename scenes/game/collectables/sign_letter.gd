extends Area2D

const PATH = "res://assets/dictionary/configuration/"

@onready var sign_image: TextureRect = $Panel/Sign
@onready var level_letter = GameManager.get_level1_letter().to_upper()
@onready var effects: AnimationPlayer = $Effects

func _ready() -> void:
	effects.play("blink")
		
func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player1" || body.name == "Player2"):
		queue_free()
		
		if (sign_image.texture.resource_path == PATH + level_letter + ".svg"):
			GameManager.add_sign_point()
			GameManager.add_health()
		else:
			GameManager.reduce_health()
		
