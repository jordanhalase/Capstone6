extends Area2D

func _on_BirdStationary_body_entered(body):
	if body.name == "Player":
		EventBus.emit_signal("bird_collected")
		queue_free()
