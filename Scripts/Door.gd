extends AnimatedSprite

class_name Door

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_DoorAnimation_animation_finished():
	pass

	#TODO: get the little birds count
func _on_Door_body_entered(body):
	if body is Player:
		if 0 > 0:
			get_tree().paused = true
			play("open")
			yield(self, "animation_finished")
			#TODO: save the birds
			play("close")
			get_tree().paused = false
