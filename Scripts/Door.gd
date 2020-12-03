extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var door = get_node("Door/DoorAnimation")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_DoorAnimation_animation_finished():
	pass


func _on_Door_body_entered(body):
	
	if body is Player:
	#TODO: get the little birds count
		if get_tree().get_nodes_in_group("BirdFollowing").size() > 0:
				get_tree().paused = true
				door.play("open")
				yield(door, "animation_finished")
				#TODO: save the birds
				door.play("close")
				get_tree().paused = false
