extends Area2D

var facesRight: bool = true

func _ready() -> void:
	position.y -= 8
	if facesRight:
		$AnimatedSprite.flip_h = true
