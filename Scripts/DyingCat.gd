extends Area2D

var facesRight = true

func _ready():
	position.y -= 8
	if facesRight: $AnimatedSprite.flip_h = true
