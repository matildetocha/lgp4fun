extends CanvasLayer

# Health
@onready var health_points_label: Label = $HealthPanel/HealthLabel
@onready var health_panel_effects: AnimationPlayer = $HealthPanel/Effects
@onready var health_panel_timer: Timer = $HealthPanel/Timer

# Game Timer
@onready var timer_label: Control = $Timer/TimerLabel
@onready var timer: Timer = $"../Timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	GameManager.connect("life_up", _life_up_an)
	GameManager.connect("lose_life", _lose_life_an)
	health_panel_effects.play("RESET")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	health_points_label.text = str(GameManager.get_health())
	timer_label.text = str(int(timer.get_time_left()))

func _life_up_an() -> void:
	health_panel_effects.play("life_up")
	health_panel_timer.start()
	await health_panel_timer.timeout
	health_panel_effects.play("RESET")

func _lose_life_an() -> void:
	health_panel_effects.play("lose_life")
	health_panel_timer.start()
	await health_panel_timer.timeout
	health_panel_effects.play("RESET")
