extends AnimatedSprite

class_name Door

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var next: BirdFollowing
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
#		print(areBirds())
#		if areBirds():
#			get_tree().paused = true
#			play("open")
#			yield(self, "animation_finished")
			#TODO: save the birds
#			print(collectBirds())
			collectBirds()
#			play("close")
#			get_tree().paused = false
			
			
#func areBirds() -> bool:
#	var birds = get_tree().get_nodes_in_group("FollowingBirds")
#	return birds[0].active


func collectBirds() -> int:
	var birds = get_tree().get_nodes_in_group("FollowingBirds")
	for bird in birds:
		if bird.active:
			
			get_tree().paused = true
			play("open")
			yield(self, "animation_finished")
			
#			var pbird = bird
#			bird = bird.next
#			pbird.active = false
			
			bird.set_active(false)

#			pbird.queue_free()
			play("close")
			++ count
	if 	get_tree().paused == true:
		get_tree().paused = false
	return count
