extends KinematicBody2D

var velocity = Vector2()
const UP = Vector2(0 , -1)
const GRAVITY = 20
const MAX_SPEED = 200
const JUMP_HEIGHT = -500
const ACCELERATION = 50

var MAP_WIDTH

func _ready():
	var parent := get_parent()
	MAP_WIDTH = parent.MAP_CELL_WIDTH*parent.cell_size.x

func _physics_process(_delta: float) -> void:
	# Integrate gravity using forward Euler method
	velocity.y += GRAVITY
	var friction = true
	
	if Input.is_action_pressed("ui_right"):
		# player moving right
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
		
	elif Input.is_action_pressed("ui_left"):
		# player moving left
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
	
	# Check if the player is on the floor
	if is_on_floor():
		# velocity.y = 0
		if Input.is_action_just_pressed("ui_up"):
			# player jumping
			velocity.y = JUMP_HEIGHT
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.2)
	else: 
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.05)
			
	velocity = move_and_slide(velocity, UP)
	level_wrap()
	
func level_wrap():
	# Wrap around the infinite map
	if position.x >= MAP_WIDTH:
		position.x -= MAP_WIDTH
	elif position.x < 0:
		position.x += MAP_WIDTH

