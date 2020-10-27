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


# TODO: Try to use signals instade
func _on_Cat_body_entered(body):
	if("Cat" in body.name):
		body.queue_free()
		var DyingCatScene = load("res://Nodes/DyingCat.tscn")
		var newDyingCat = DyingCatScene.instance()
		newDyingCat.position = get_position()
		newDyingCat.velocity.x = velocity.x*2
		replace_by(newDyingCat)
		queue_free()
