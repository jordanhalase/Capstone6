extends KinematicBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
const GRAVITY = 20
const SPEED = 35
const FLOOR = Vector2(0 , -1)


var velocity = Vector2()

var direction = 1

var is_in_animation = false

onready var player = get_node("../Player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	if !is_in_animation:
		walk()
	
	if is_on_wall():
		direction = direction * -1
		$AreaCheck.rotate(PI)
		
	if $AreaCheck.is_colliding():
		var node = $AreaCheck.get_collider()
		if position.y <= player.position.y && node.jumpAcrossY == null && node.fallY == null:
			pass
		else:
			is_in_animation = true
			sit()
			jump()
		
		
	velocity = move_and_slide(velocity, FLOOR)
	get_parent().level_wrap(self)
	
func sit():
	velocity.x = 0
	
func jump():
	pass
	
func walk():
	velocity.x = SPEED * direction
	velocity.y += GRAVITY

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
	
