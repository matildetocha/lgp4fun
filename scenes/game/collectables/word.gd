extends Area2D

@onready var label: Label = $Label
@onready var effects: AnimationPlayer = $Effects
@onready var level2_man = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	effects.play("blink")

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player1" || body.name == "Player2"):
		queue_free()
		
		if (level2_man.current_word):	
			if (label.text == level2_man.current_word):
				level2_man.vocab_assembly("word")
				GameManager.add_big_point()
				GameManager.add_health()
				
			else:
				GameManager.reduce_health()
