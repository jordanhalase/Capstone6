extends KinematicBody2D

const GRAVITY = 4
const SPEED = 72
const FLOOR = Vector2(0, -1)

# Give a small range where the player can be considered on the same level
# as the cat is
const EPSILON = 8

var velocity = Vector2()

# This is used to index an array where 0 is left and 1 is right
var direction: int = 1

# Used to prevent multiple collisions with the same AI block
# before completing the decided move
var thought = false

# Used similarly to `thought` but for decisions where the
# cat stays on the ground
var reversed = false

onready var player = get_node("../Player")

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
		thought = true
		if position.y > (player.position.y + EPSILON) && ai.jumpAbove[direction]:
			callback_params = [ai.jumpAboveVel[direction], false]
		elif position.y < (player.position.y - EPSILON) && ai.jumpBelow[direction]:
			callback_params = [ai.jumpBelowVel[direction], false]
		elif ai.jumpAcross[direction]:
			callback_params = [ai.jumpAcrossVel[direction], false]
		else:
			var dx = position.x - player.position.x
			if (dx > 0 && dx < 120 && direction == 1) || (dx < 0 && dx > -120 && direction == 0):
				callback_params = [null, true]
			else:
				thought = false
		if thought:
			$Timer.start()
			sit()
		
	velocity = move_and_slide(velocity, FLOOR)
	get_parent().level_wrap(self)
	
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
