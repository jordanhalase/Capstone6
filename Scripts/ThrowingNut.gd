extends Area2D

const SPEED = 100

var velocity = Vector2()

var direction = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	



func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
