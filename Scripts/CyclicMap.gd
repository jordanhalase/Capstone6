extends TileMap

class_name CyclicMap

# The width of the entire map in units of 8x8 cells
export var MAP_CELL_WIDTH: int = 60

const BirdStationary = preload("res://Scripts/BirdStationary.gd")
const BirdUnchained = preload("res://Scripts/BirdUnchained.gd")
const BirdChain = preload("res://Scripts/BirdChain.gd")
const HUD = preload("res://Nodes/HUD.tscn")

onready var door = get_node("Door/DoorAnimation")
var birdChain

# Map width in pixels
var MAP_WIDTH: float

func _ready() -> void:
	MAP_WIDTH = MAP_CELL_WIDTH*cell_size.x
	
	var used_cells := .get_used_cells()
	for coord in used_cells:
		var id: int = .get_cell(coord.x, coord.y)
		.set_cell(coord.x + MAP_CELL_WIDTH, coord.y, id)
		.set_cell(coord.x - MAP_CELL_WIDTH, coord.y, id)
	
	var num_birds: int = 0
	var children: Array = get_children()
	for child in children:
		if (child is BirdStationary or child is BirdUnchained):
			print(child)
			num_birds += 1
			
	birdChain = BirdChain.new(num_birds)
	birdChain.set_name("BirdChain")
	add_child(birdChain)
	
	var hud := HUD.instance()
	hud.set_name("HUD")
	add_child(hud)
	
	startDoor()
	
	
func startDoor() -> void:
	$Player.hide()
	get_tree().paused = true
	door.play("open")
	yield(door, "animation_finished")
	$Player.show()
	door.play("close")
	get_tree().paused = false

#func checkDoor() -> void:
#	pass
#
func getBirdsCount() -> int:
	return get_tree().get_nodes_in_group("BirdFollowing").size();

#func _physics_process(_delta: float) -> void:
#	pass
	
	
func level_wrap(node: Node) -> bool:
	# Wrap around the infinite map
	var wrapped: bool = node.position.x >= MAP_WIDTH or node.position.x < 0
	node.position.x = wrapf(node.position.x, 0, MAP_WIDTH)
	return wrapped
