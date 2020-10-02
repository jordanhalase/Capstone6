extends "res://HUD.gd"

func _on_TestingPoint_body_entered(body):
	if body.name == "Player":
		get_node("/root/Hud").score += 100
		queue_free()
	pass # Replace with function body.
