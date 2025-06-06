extends CharacterBody2D

var speed = 400.0
var jump_velocity = -525.0
var acceleration_value = 0.01
var slide_value = 0.01
var full_stop_value = 15

var on_ice = false

@onready var player_2: AnimatedSprite2D = $AnimatedSprite2D
@onready var effects: AnimationPlayer = $Effects
@onready var hurt_timer: Timer = $HurtTimer

func _ready() -> void:
	effects.play("RESET")

func _physics_process(delta: float) -> void:
	# Animations
	if (velocity.x > 1 || velocity.x < -1):
		player_2.animation = "walking"
	else:
		player_2.animation = "default"
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		player_2.animation = "jumping"
		
	# Handle jump.
	if Input.is_action_just_pressed("p2_jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("p2_left", "p2_right")
	if on_ice:
		_on_ice_movement(direction)
	else:
		_normal_movement(direction)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	player_2.flip_h = isLeft

func _on_ice_movement(direction) -> void:
	if direction:
		velocity.x = lerp(velocity.x, direction * speed, acceleration_value)
	else:
		velocity.x = lerp(velocity.x, 0.0, slide_value)
		
		if velocity.x < full_stop_value && velocity.x > -full_stop_value:
			velocity.x = 0

func _normal_movement(direction) -> void:
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, 25)

func _on_mud_areas_body_entered(body: Node2D) -> void:
	if (body.name == "Player2"):
		speed = 100.0
		jump_velocity = -200.0

func _on_mud_areas_body_exited(body: Node2D) -> void:
	if (body.name == "Player2"):
		speed = 400.0
		jump_velocity = -525.0

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if (area.is_in_group("enemies")):
		effects.play("hurt_blink")
		hurt_timer.start()
		await hurt_timer.timeout
		effects.play("RESET")
	
	elif (area.is_in_group("collectables") && GameManager.get_health() < GameManager.MAX_HEALTH):
		effects.play("life_up")
		hurt_timer.start()
		await hurt_timer.timeout
		effects.play("RESET")

func _on_ice_areas_body_entered(body: Node2D) -> void:
	if (body.name == "Player2"):
		on_ice = true

func _on_ice_areas_body_exited(body: Node2D) -> void:
	if (body.name == "Player2"):
		on_ice = false
