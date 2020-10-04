extends KinematicBody2D

var velocity := Vector2(50.0, 0)

onready var map = get_parent()
onready var timer = get_node("Timer")

func _ready():
	timer.set_wait_time(1)
	timer.start()

func _physics_process(delta):
	if is_on_wall():
		velocity *= -1.0
	if velocity.x > 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	velocity = move_and_slide(velocity, get_floor_normal())
	map.level_wrap(self)
	
func _on_Timer_timeout():
	timer.start()
	velocity.x *= -1.0
