extends TileMap

# The width of the entire map in units of 8x8 cells
export var MAP_CELL_WIDTH: int = 60

# Map width in pixels
var MAP_WIDTH

func _ready():
	MAP_WIDTH = MAP_CELL_WIDTH*cell_size.x
	
	var used_cells := .get_used_cells()
	for coord in used_cells:
		var id: int = .get_cell(coord.x, coord.y)
		.set_cell(coord.x + MAP_CELL_WIDTH, coord.y, id)
		.set_cell(coord.x - MAP_CELL_WIDTH, coord.y, id)

# Other nodes can use this to keep themselves from wandering out of the level
func level_wrap(node):
	# Wrap around the infinite map
	if node.position.x >= MAP_WIDTH:
		node.position.x -= MAP_WIDTH
	elif node.position.x < 0:
		node.position.x += MAP_WIDTH
