extends KinematicBody2D

const UP = Vector2(0 , -1)
const GRAVITY = 4
const MAX_HSPEED = 80
const MAX_VSPEED = 168
const JUMP_HEIGHT = 164
const ACCELERATION = 6
const FRICTION_COEF = 0.16
const FRICTION = ACCELERATION*FRICTION_COEF

# The size of the delay buffer
const DELAY_FRAMES = 10

var velocity: Vector2 = Vector2()
onready var map = get_parent()

func _ready():
	var delayBuffer := DelayBuffer.new(DELAY_FRAMES, position)

func _physics_process(_delta: float) -> void:
	# Integrate gravity using forward Euler method
	velocity.y = min(MAX_VSPEED, velocity.y + GRAVITY)
	
	if Input.is_action_pressed("ui_right"):
		# player moving right
		$Sprite.set_flip_h(false)
		velocity.x = min(velocity.x + ACCELERATION, MAX_HSPEED)
		
	elif Input.is_action_pressed("ui_left"):
		# player moving left
		$Sprite.set_flip_h(true)
		velocity.x = max(velocity.x - ACCELERATION, -MAX_HSPEED)
	
	# Check if the player is on the floor
	if is_on_floor():
		# velocity.y = 0
		if Input.is_action_pressed("ui_up"):
			# player jumping
			velocity.y = -JUMP_HEIGHT
		if velocity.x >= 0:
			velocity.x = max(0, velocity.x - FRICTION)
		else:
			velocity.x = min(0, velocity.x + FRICTION)
			
	velocity = move_and_slide(velocity, UP)
	map.level_wrap(self)
