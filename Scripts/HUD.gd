extends Node2D

var score = 0 setget add_score

func add_score(value): 
	score = value
	get_node("HUD/score").set_text("SCORE: " +str(score))
