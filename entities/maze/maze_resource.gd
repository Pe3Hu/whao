class_name MazeResource extends Resource


var planet: PlanetResource:
	set = set_planet

var crossroads: Array[CrossroadResource]
var trails: Array[TrailResource]
var grids: Dictionary

var rows: int = 5
var cols: int = 5

var crossroad_size: Vector2 = Vector2(96, 96)
var trail_size: Vector2 = Vector2(96, 96)
var total_size: Vector2


func set_planet(planet_: PlanetResource) -> MazeResource:
	planet = planet_
	total_size = crossroad_size * Vector2(cols, rows) + trail_size * Vector2(cols - 1, rows - 1)
	init_crossroads()
	return self

func init_crossroads() -> void:
	grids.crossroad = {}
	
	for y in rows:
		for x in cols:
			var grid = Vector2i(x, y)
			var crossroad = CrossroadResource.new()
			crossroad.set_grid(grid).set_maze(self)
