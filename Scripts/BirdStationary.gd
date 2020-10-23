extends "res://Scripts/HUD.gd"

signal bird_collected

func _on_BirdStationary_body_entered(body):
	if body.name == "Player":
		get_node("../BirdChain").increment_chain()
		get_node("/root/Hud").score += 100
		emit_signal("bird_collected")
		queue_free()
