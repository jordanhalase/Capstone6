extends Area2D

func _on_BirdStationary_body_entered(_body: KinematicBody2D) -> void:
	# Player.gd is not available here due to Godot weirdness with global
	# types which is planned to be fixed in Godot 4.
	# We don't need it here anyway since the player is the only thing that
	# collides with this based on its collision mask.
	
	#if body is Player:
		EventBus.emit_signal("bird_collected")
		queue_free()
