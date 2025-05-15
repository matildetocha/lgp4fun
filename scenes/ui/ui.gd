extends CanvasLayer

@onready var level_letter = GameManager.get_level1_letter()

# Points
@onready var health_points_label: Label = $HealthPanel/HealthLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	health_points_label.text = str(GameManager.get_health())
