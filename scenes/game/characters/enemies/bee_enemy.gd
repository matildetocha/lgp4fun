extends CharacterBody2D

const SPEED = 100.0
var direction: Vector2
@onready var bee_enemy: AnimatedSprite2D = $AnimatedSprite2D
	
func _physics_process(_delta: float) -> void:
	# Animations
	if (velocity.x > 1 || velocity.x < -1):
		bee_enemy.animation = "flying"
	
	# Collision with wall
	if (is_on_wall()): 
		direction.x *= -1
	
	if direction.x == -1:
		bee_enemy.flip_h = false
	else:
		bee_enemy.flip_h = true
		
	velocity = direction * SPEED 
	move_and_slide()


func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([1.5, 2.0, 2.5])
	
	direction = choose([Vector2.RIGHT, Vector2.LEFT])

func choose(array): 
	array.shuffle()
	return array.front()
