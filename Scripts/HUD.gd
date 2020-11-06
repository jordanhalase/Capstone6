extends Node2D

var score: int = 0
var lives: int = 4

onready var LivesUI = $Control/LivesUI
func _ready() -> void:
	# warning-ignore:return_value_discarded
	EventBus.connect("bird_collected", self, "update_score")
	EventBus.connect("cat_catch", self, "update_lives")
	
func update_score() -> void:
	score += 10
	get_node("HUD/score").set_text("SCORE: " + str(score))

func update_lives() -> void: 
	lives = clamp(lives, 0, 4)
	lives -= 1
	get_node("Control/lives").set_text("LIVE: " + str(lives))
	if LivesUI != null: 
		LivesUI.rect_size.x = lives * 16
