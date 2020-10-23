extends TileMap

class_name CyclicMap

# The width of the entire map in units of 8x8 cells
export var MAP_CELL_WIDTH: int = 60

const BirdStationary = preload("res://Scripts/BirdStationary.gd")
const BirdUnchained = preload("res://Scripts/BirdUnchained.gd")
const BirdChain = preload("res://Scripts/BirdChain.gd")
const HUD = preload("res://Nodes/HUD.tscn")

# Map width in pixels
var MAP_WIDTH

func _ready():
	MAP_WIDTH = MAP_CELL_WIDTH*cell_size.x
	
	var used_cells := .get_used_cells()
	for coord in used_cells:
		var id: int = .get_cell(coord.x, coord.y)
		.set_cell(coord.x + MAP_CELL_WIDTH, coord.y, id)
		.set_cell(coord.x - MAP_CELL_WIDTH, coord.y, id)
	
	var num_birds = 0
	var children = get_children()
	for child in children:
		if (child is BirdStationary or child is BirdUnchained):
			print(child)
			num_birds += 1
			
	var birdChain := BirdChain.new(num_birds)
	birdChain.set_name("BirdChain")
	add_child(birdChain)
	
	var hud := HUD.instance()
	hud.set_name("HUD")
	add_child(hud)

# Other nodes can use this to keep themselves from wandering out of the level
func level_wrap(node):
	# Wrap around the infinite map
	node.position.x = wrapf(node.position.x, 0, MAP_WIDTH)
