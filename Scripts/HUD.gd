extends Node2D

var score = 0 setget update_score

func update_score(value): 
	score = value
	get_node("HUD/score").set_text("SCORE: " +str(score))
