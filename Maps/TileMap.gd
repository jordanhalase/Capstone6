extends TileMap

# The width of the entire map in units of 8x8 cells
export var MAP_CELL_WIDTH: int = 60

func _ready():
	var used_cells := .get_used_cells()
	for coord in used_cells:
		var id: int = .get_cell(coord.x, coord.y)
		.set_cell(coord.x + MAP_CELL_WIDTH, coord.y, id)
		.set_cell(coord.x - MAP_CELL_WIDTH, coord.y, id)
