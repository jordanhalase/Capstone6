extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 4
const MAX_HSPEED = 80
const MAX_VSPEED = 168
const JUMP_HEIGHT = 164
const ACCELERATION = 6
const FRICTION_COEF = 0.16
const FRICTION = ACCELERATION*FRICTION_COEF

const COCONUT= preload("res://Nodes/Weapon_In_Motion.tscn")

var velocity: Vector2 = Vector2()
onready var map = get_parent()

var hasThrowable: bool = false

func _ready():
	pass

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
			
	if Input.is_action_just_pressed("shoot"):
		if hasThrowable == true:
			var coconut = COCONUT.instance()
			get_parent().add_child(coconut)
			#chooses which side to shoot from
			if $Sprite.flip_h == false:
				coconut.position = $ShootRight.global_position
			else:
				coconut.position = $ShootLeft.global_position
				coconut.direction = -1
			
			hasThrowable = false
			
	velocity = move_and_slide(velocity, UP)

# This was commented here because the score is counted multiple
# times due to the follwingBirds!
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		if collision.collider.name == "BirdUnchained":
#			# TODO: figure out how to add the little bird back to the chain
#			collision.collider.queue_free()
			
	map.level_wrap(self)
# lets pick up nut node know if the player already has a nut
func pick_up() -> bool:
	if hasThrowable == false:
		hasThrowable = true
		return true
	else:
		return false
