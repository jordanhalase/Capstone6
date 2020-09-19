extends KinematicBody2D

var motion = Vector2()
const UP = Vector2(0 , -1)
const GRAVITY = 20 
const MAX_SPEED = 200
const JUMP_HEIGHT = -500
const ACCELERATION = 50 

func _physics_process(_delta):
	motion.y += GRAVITY
	# the higher the player jump the more gravity 
	var friction = true
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
	# player moving right
		
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
	# player moving left 
	
	# is_on_floor check if the player is on the floor or not 
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
			# player jumping 
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
		
	else: 
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
		
	motion = move_and_slide(motion, UP)
	pass

