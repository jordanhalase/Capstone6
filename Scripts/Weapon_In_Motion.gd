extends KinematicBody2D

const SPEED: float = 250.0
var velocity: Vector2 = Vector2()
var direction: int = 1

onready var map = get_parent()

var DyingCatScene = preload("res://Nodes/DyingCat.tscn")
var Cat = preload("res://Scripts/Cat.gd")

# Do not reset the timer when hitting multiple cats.
var hit_cat: bool = false

func _physics_process(_delta):
	velocity.x = SPEED*direction
	velocity = move_and_slide(velocity)
	if map.level_wrap(self) and !hit_cat:
		queue_free()

# TODO: Destroy self instantly if offscreen AND did not hit a cat.
# VisibilityNotifier won't work due to infinite scrolling, so CyclicMap
# will need to check if something is off screen based on the player's
# x position somehow once infinite scrolling is re-implemented.

func _on_Cat_body_entered(body):
	if(body is Cat):
		body.queue_free()
		var dyingCat = DyingCatScene.instance()
		call_deferred("add_child", dyingCat)
		if(velocity.x >= 0):
			dyingCat.facesRight = true
		else:
			dyingCat.facesRight = false
		if !hit_cat:
			hit_cat = true
			$Timer.start()

# This is called AFTER hitting a cat.
func _on_Timer_timeout():
	queue_free()
