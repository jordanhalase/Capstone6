extends KinematicBody2D

const GRAVITY: float = 4.0
const SPEED: float = 72.0
const UP := Vector2(0, -1)

# Maximum distance from the player that the cat will turn around
const MAX_DISTANCE: float = 240.0

# Give a small range where the player can be considered on the same level
# as the cat is
const EPSILON: float = 8.0

var velocity := Vector2()

# This is used to index an array where 0 is left and 1 is right
export var facesRight: bool = true

# Used to prevent multiple collisions with the same AI block
# before completing the decided move
var thinking: bool = false

# Used similarly to `thinking` but for decisions where the
# cat stays on the ground
var reversed: bool = false

onready var player := get_node("../Player")
onready var map := get_parent()

# Parameters for the timer callback
# [jumpY: float, changed_direction: bool]
var callback_params = [0.0, false]

func _ready() -> void:
	$AnimatedSprite.set_flip_h(!facesRight)
	walk()

func _physics_process(_delta: float) -> void:
	
	velocity.y += GRAVITY
	
	if is_on_wall():
		flip_direction()
	
	if !thinking:
		walk()
		
	velocity = move_and_slide(velocity, UP)
	map.level_wrap(self)
	
	if reversed:
		# This needs to happen AFTER move_and_slide to prevent
		# double collisions with the AI block
		reversed = false
		thinking = false
	
func sit() -> void:
	velocity.x = 0
	#$AnimatedSprite.play("stop")
	
func jump(jumpY) -> void:
	velocity.y = -jumpY
	thinking = false
	
func walk() -> void:
	if facesRight:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED
	$AnimatedSprite.play("run")

func flip_direction() -> void:
	facesRight = !facesRight
	$AnimatedSprite.set_flip_h(!facesRight)

# Decision callback from AIBlock
func _decide(ai) -> void:
	if !thinking:
		if facesRight == ai.facesRight:
			thinking = true
			if position.y > (player.position.y + EPSILON) && ai.jumpAbove:
				callback_params = [ai.jumpAboveVel, false]
			elif position.y < (player.position.y - EPSILON) && ai.jumpBelow:
				callback_params = [ai.jumpBelowVel, false]
			else:
				var dx = position.x - player.position.x
				if (dx > 0 && dx < MAX_DISTANCE && facesRight == true) || (dx < 0 && dx > -MAX_DISTANCE && facesRight == false):
					callback_params = [null, true]
				elif ai.jumpAcross:
					callback_params = [ai.jumpAcrossVel, false]
				else:
					thinking = false
					walk()
			if thinking:
				$Timer.start()
				sit()

# Timer callback
func _on_Timer_timeout() -> void:
	var jumpY = callback_params[0]
	var changed_direction = callback_params[1]
	if changed_direction:
		flip_direction()
		reversed = true
	else:
		jump(jumpY)
