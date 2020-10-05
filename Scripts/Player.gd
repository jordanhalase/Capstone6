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

const BirdFollowing = preload("res://Nodes/BirdFollowing.tscn")

var delayBuffer = null
var next = null

func _ready():
	delayBuffer = DelayBuffer.new(DELAY_FRAMES, position)
	
	var lag = BirdFollowing.instance()
	add_child(lag)
	lag.set_global_position(position)
	next = lag
	
	var bird
	for i in range(0):
		bird = BirdFollowing.instance()
		add_child(bird)
		bird.delayBuffer = DelayBuffer.new(DELAY_FRAMES, position)
		bird.set_global_position(position + Vector2(i, i))
		lag.next = bird
		lag = bird

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

# This was commented here because the score is counted multiple
# times due to the follwingBirds!
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if collision.collider.name == "BirdUnchained":
#			# TODO: figure out how to add the little bird back to the chain
#			collision.collider.queue_free()
			
	map.level_wrap(self)
	
	next.set_global_position(delayBuffer.enqueue(position))
	#var bird = next
	#var lag = self
	#while bird != null:
	#	bird.set_global_position(lag.delayBuffer.enqueue(lag.position))
	#	lag = bird
	#	bird = bird.next
