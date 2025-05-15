extends CharacterBody2D

var speed = 85.0
var direction = Vector2.RIGHT
var hit = false
@onready var slime_enemy: AnimatedSprite2D = $AnimatedSprite2D
@onready var ledge_check_right: RayCast2D = $LedgeCheckRight
@onready var ledge_check_left: RayCast2D = $LedgeCheckLeft
	
func _physics_process(_delta: float) -> void:
	# Animations
	if (velocity.x > 1 || velocity.x < -1):
		slime_enemy.animation = "walking"	
	
	# Collision with wall or ledge
	var found_ledge_right = not ledge_check_right.is_colliding()
	var found_ledge_left= not ledge_check_left.is_colliding()
	
	if (is_on_wall() or found_ledge_right or found_ledge_left):
		direction.x *= -1
	
	if direction.x == -1:
		slime_enemy.flip_h = false
	else:
		slime_enemy.flip_h = true
		
	velocity = direction * speed 
	move_and_slide()
