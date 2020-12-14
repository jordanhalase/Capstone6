extends Node2D

const CAT := preload("res://Nodes/Cat.tscn")

var alive = false

onready var map: CyclicMap = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	map.level_wrap(self)

	if !alive:
		$Timer.start()
		#get_parent().add_child(cat)
		alive = true
	pass
	
func _on_Timer_timeout() -> void:
	var cat = CAT.instance()
	cat.spawnNode = self
	cat.position = $Position2D.global_position
	get_parent().add_child(cat)
	alive = true

func _reset_Timer() -> void:
	$Timer.start()
