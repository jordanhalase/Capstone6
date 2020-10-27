extends Area2D


# Declare member variables here. Examples:
var velocity = Vector2(0,0)
var facesLeft = true
#TODO: Add the horizantal movement then disappear!

# Called when the node enters the scene tree for the first time.
func _ready():
	position.y -= 8
	if !facesLeft: $AnimatedSprite.flip_h = true
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(velocity)
