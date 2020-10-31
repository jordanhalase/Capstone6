extends Area2D

func _on_Thowable_body_entered(body: KinematicBody2D) -> void:
	if body is Player:
		var player := body as Player
		if player.pick_up():
			queue_free()
