extends AnimatedSprite

class_name Door

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var next: BirdFollowing

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
		collectBirds()
			
func collectBirds() -> void:
	var count: int = 0
	var birds = get_tree().get_nodes_in_group("FollowingBirds")
	for bird in birds:
		if bird.active:
			get_tree().paused = true
			play("open")
			yield(self, "animation_finished")
			bird.set_active(false)
			play("close")
			count = count + 1
	if 	get_tree().paused == true:
		get_tree().paused = false
	if count > 0:
		EventBus.emit_signal("bird_collect", count)
