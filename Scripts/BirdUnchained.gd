extends KinematicBody2D

const UP: Vector2 = Vector2(0, -1)
const GRAVITY: float = 4.0
const SPEED: float = 50.0
var velocity: Vector2 = Vector2(SPEED, 0)

onready var map := get_parent()
onready var timer: Timer = get_node("Timer")

func _ready() -> void:
	timer.set_wait_time(1)
	timer.start()

func _physics_process(_delta: float) -> void:
	velocity.y += GRAVITY
	
	if is_on_wall():
		velocity *= -1.0
	if velocity.x > 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	velocity = move_and_slide(velocity, UP)
	map.level_wrap(self)
	
func _on_Timer_timeout() -> void:
	timer.start()
	velocity.x *= -1.0

func _on_Area2D_body_entered(_body: KinematicBody2D) -> void:
	get_node("../BirdChain").increment_chain()
	queue_free()
