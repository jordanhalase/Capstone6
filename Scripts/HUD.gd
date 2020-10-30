extends Node2D

var score = 0 

func _ready() ->void:
	# warning-ignore:return_value_discarded
	EventBus.connect("bird_collected", self, "update_score")
	
func update_score(): 
	score = score + 10
	get_node("HUD/score").set_text("SCORE: " +str(score))
