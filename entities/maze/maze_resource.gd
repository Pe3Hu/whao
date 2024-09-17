class_name MazeResource extends Resource


var planet: PlanetResource:
	set = set_planet

var crossroads: Array[CrossroadResource]
var trails: Array[TrailResource]
var grids: Dictionary
var previous_origin: CrossroadResource
var origin: CrossroadResource
var deadends: Array[CrossroadResource]

var n: int = 12
var rows: int = n
var cols: int = n
var repeats: int = 5
var max_deadend_remoteness: int = 0
var limit_deadend_remoteness: int = 10

var crossroad_size: Vector2 = Vector2(64, 64)
var trail_size: Vector2 = Vector2(64, 64)
var total_size: Vector2

const windores = ["north", "east", "south", "west"]
const horizontal = ["west", "east"]
const vertical = ["north", "south"]


func set_planet(planet_: PlanetResource) -> MazeResource:
	planet = planet_
	total_size = crossroad_size * Vector2(cols, rows) + trail_size * Vector2(cols - 1, rows - 1)
	init_crossroads()
	init_trails()
	init_inputs_and_outputs()
	roll_random_pattern()
	calc_crossroads_deadend_remoteness()
	limit_max_deadend_remoteness()
	return self
	
func init_crossroads() -> void:
	for y in rows:
		for x in cols:
			var grid = Vector2(x, y)
			var crossroad = CrossroadResource.new()
			crossroad.set_grid(grid).set_maze(self)
	
func init_trails() -> void:
	for crossroad in crossroads:
		var directions = [Vector2(0.5, 0), Vector2(0, 0.5)]
		
		for direction in directions:
			var trail_grid = crossroad.grid + direction
			var crossroad_grid = crossroad.grid + direction * 2
			
			if !grids.has(trail_grid) and grids.has(crossroad_grid):
				var trail = TrailResource.new()
				trail.set_grid(trail_grid).set_maze(self)
	
func init_inputs_and_outputs() -> void:
	for trail in trails:
		var crossroad_input = trail.windroses[trail.windrose]
		var crossroad_output = trail.get_another_crossroad(crossroad_input)
		crossroad_input.inputs.append(trail)
		crossroad_output.outputs.append(trail)
	
func roll_random_pattern() -> void:
	origin = grids[Vector2(cols - 1, rows - 1)]
	origin.is_origin = true
	
	for _i in repeats * rows * cols:
		origin.roll_next_origin()
	
func reset_crossroads_deadend_remoteness() -> void:
	max_deadend_remoteness = 0
	
	for crossroad in crossroads:
		crossroad.deadend_remoteness = -1
	
func calc_crossroads_deadend_remoteness() -> void:
	var visited = []
	var current: Array[CrossroadResource]
	var next = []
	var border_crossroads = crossroads.filter(func(a): return a.grid.x == 0 or a.grid.x == cols -1 or a.grid.y == 0 or a.grid.y == rows -1)
	
	for crossroad in border_crossroads:
		var _trails = crossroad.trails.keys().filter(func(a): return a.is_active)
		
		if _trails.size() == 1:
			current.append(crossroad)
	
	var unvisited = crossroads.filter(func(a): return !current.has(a))
	
	while !unvisited.is_empty() and max_deadend_remoteness < cols * rows:
		next.clear()
		
		for crossroad in current:
			if crossroad.deadend_remoteness == -1:
				crossroad.deadend_remoteness = max_deadend_remoteness
				var neighbors = crossroad.neighbors.keys().filter(func(a): return crossroad.neighbors[a].is_active and !visited.has(a) and !next.has(a))
				next.append_array(neighbors)
		
		deadends.clear()
		deadends.append_array(current)
		visited.append_array(current)
		unvisited = unvisited.filter(func(a): return !visited.has(a))
		current.clear()
		current.append_array(next)
		max_deadend_remoteness += 1
	
func recalc_max_deadend_remoteness() -> void:
	if limit_deadend_remoteness < max_deadend_remoteness:
		deadends.sort_custom(func(a, b): return origin.get_manhattan_distance(a) < origin.get_manhattan_distance(b))
		deadends.erase(origin)
		deadends.erase(previous_origin)
		var deadend
		var on_exit = deadends.is_empty()
		
		if !on_exit:
			deadend = deadends.front()
			on_exit = origin.neighbors.has(deadend) and origin.deadend_remoteness == deadend.deadend_remoteness
			
			if !on_exit:
				on_exit = abs(origin.grid.x - deadend.grid.x) == 1 or abs(origin.grid.y - deadend.grid.y) == 1
		
		if on_exit:
			origin.move_origin_to_exit()
		else:
			var counter = 100
			
			while origin != deadend and counter > 0:
				origin.move_origin_to_deadend(deadend)
				counter -= 1
		
		reset_crossroads_deadend_remoteness()
		calc_crossroads_deadend_remoteness()
	
func limit_max_deadend_remoteness() -> void:
	var counter = 500
	
	while limit_deadend_remoteness < max_deadend_remoteness and counter > 0:
		recalc_max_deadend_remoteness()
		counter -= 1
