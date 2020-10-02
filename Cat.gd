extends KinematicBody2D

const GRAVITY: float = 4.0
const SPEED: float = 72.0
const FLOOR := Vector2(0, -1)

# Maximum distance from the player that the cat will turn around
const MAX_DISTANCE: float = 120.0

# Give a small range where the player can be considered on the same level
# as the cat is
const EPSILON: float = 8.0

var velocity := Vector2()

# This is used to index an array where 0 is left and 1 is right
var direction: bool = true

# Used to prevent multiple collisions with the same AI block
# before completing the decided move
var thought: bool = false

# Used similarly to `thought` but for decisions where the
# cat stays on the ground
var reversed: bool = false

onready var player := get_node("../Player")
onready var map := get_parent()

# Parameters for the timer callback
# [jumpY: float, changed_direction: bool]
var callback_params = [0.0, false]

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if !is_on_floor():
		thought = false
	
	if !thought:
		walk()
	
	if is_on_wall():
		direction = !direction
		$AreaCheck.rotate(PI)
		
	if $AreaCheck.is_colliding() && !thought:
		var ai = $AreaCheck.get_collider()
		if direction == ai.facesRight:
			thought = true
			if position.y > (player.position.y + EPSILON) && ai.jumpAbove:
				callback_params = [ai.jumpAboveVel, false]
			elif position.y < (player.position.y - EPSILON) && ai.jumpBelow:
				callback_params = [ai.jumpBelowVel, false]
			else:
				var dx = position.x - player.position.x
				if (dx > 0 && dx < MAX_DISTANCE && direction == true) || (dx < 0 && dx > -MAX_DISTANCE && direction == false):
					callback_params = [null, true]
				elif ai.jumpAcross:
					callback_params = [ai.jumpAcrossVel, false]
				else:
					thought = false
			if thought:
				$Timer.start()
				sit()
		
	velocity = move_and_slide(velocity, FLOOR)
	map.level_wrap(self)
	
	if reversed:
		# This needs to happen AFTER move_and_slide to prevent
		# double collisions with the AI block
		reversed = false
		thought = false
	
func sit():
	velocity.x = 0
	
func jump(jumpY):
	velocity.y = -jumpY
	print("Cat jumped ", jumpY, " units")
	
func walk():
	if direction:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED
	velocity.y += GRAVITY

# Timer callback
func _on_Timer_timeout():
	var jumpY = callback_params[0]
	var changed_direction = callback_params[1]
	if changed_direction:
		direction = !direction
		walk()
		reversed = true
	else:
		jump(jumpY)
