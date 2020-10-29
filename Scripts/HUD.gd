extends Node2D

var score = 0 

func _ready() ->void:
	EventBus.connect("bird_collected", self, "update_score")
	
func update_score(): 
	score = score + 10
	get_node("HUD/score").set_text("SCORE: " +str(score))
