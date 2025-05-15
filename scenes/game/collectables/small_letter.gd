extends Area2D

@onready var label: Label = $Label
@onready var level_letter = GameManager.get_level1_letter()
@onready var effects: AnimationPlayer = $Effects

func _ready() -> void:
	effects.play("blink")
	
func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player1" || body.name == "Player2"):
		queue_free()
		
		if (label.text == level_letter):
			GameManager.add_small_point()
			GameManager.add_health()
		else:
			GameManager.reduce_health()
