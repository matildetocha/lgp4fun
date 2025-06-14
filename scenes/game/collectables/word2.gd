extends Area2D

@onready var label: Label = $Label
@onready var effects: AnimationPlayer = $Effects
@onready var level3_man = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	effects.play("blink")

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player1" || body.name == "Player2"):
		queue_free()
		
		if (level3_man.current_word):	
			if (self.is_in_group("collectables")):
				level3_man.add_vocab(level3_man.current_word["name"].to_lower())
				level3_man.vocab_assembly()
				GameManager.add_big_point()
				GameManager.add_health()
				
			else:
				GameManager.reduce_health()
