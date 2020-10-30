extends Area2D

onready var player = get_node("../Player")

func _on_Thowable_body_entered(body: PhysicsBody2D) -> void:
	if(body == player):
		if body.pick_up():
			queue_free()
