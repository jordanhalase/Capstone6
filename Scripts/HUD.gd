extends Node2D

var score: int = 0
var lives: int = 4

onready var LivesUI = $Control/LivesUI
func _ready() -> void:
	# warning-ignore:return_value_discarded
	EventBus.connect("bird_collected", self, "update_score")
	EventBus.connect("cat_catch", self, "update_lives")
	EventBus.connect("bird_dropped", self, "deincrement_score")
	
func update_score() -> void:
	score += 10
	get_node("HUD/Score_Num").set_text(str(score))

func deincrement_score() -> void:
	score -= 10
	get_node("HUD/Score_Num").set_text(str(score))

func update_lives() -> void: 
	if lives != 0:
		lives -= 1
	if lives == 0:
		LivesUI.rect_size.x = 0
	get_node("Control/Lives_Num").set_text(str(lives))
	if LivesUI != null: 
		LivesUI.rect_size.x = lives * 8
