class_name CrossroadResource extends Resource


var maze: MazeResource:
	set = set_maze
var grid: Vector2:
	set = set_grid
var is_origin: bool
var inputs: Array[TrailResource]
var outputs: Array[TrailResource]
var trails: Dictionary
var neighbors: Dictionary
var index: int
var deadend_remoteness: int = -1
var hazard: int
var heat: float
var terrain: String

var arrow_size: Vector2 = Vector2(32, 32)


func set_grid(grid_: Vector2) -> CrossroadResource:
	grid = grid_
	return self
	
func set_maze(maze_: MazeResource) -> CrossroadResource:
	maze = maze_
	index = maze.crossroads.size()
	maze.crossroads.append(self)
	maze.grids[grid] = self
	heat = maze.noise.get_noise_2dv(grid)
	return self
	
func inactive_all_outputs() -> void:
	for output in outputs:
		output.is_active = false
	
func roll_next_origin() -> Dictionary:
	var result = {}
	
	if is_origin:
		result.crossroads = [self]
		result.trails = []
		var options = Array(neighbors.keys())
		options.erase(maze.previous_origin)
		set_new_origin(options)
		result.trails.append_array(maze.origin.outputs)
	
	return result
	
func move_origin_to_deadend(deadend_: CrossroadResource) -> void:
	var options = neighbors.keys()
	options.sort_custom(func(a, b): return deadend_.get_manhattan_distance(a) < deadend_.get_manhattan_distance(b))
	options = options.filter(func(a): return deadend_.get_manhattan_distance(a) == deadend_.get_manhattan_distance(options[0]))
	var remoteness = options.front().deadend_remoteness#-1
	
	for neighbor in options:
		if remoteness > neighbor.deadend_remoteness:
			remoteness = neighbor.deadend_remoteness
	
	options = options.filter(func(a): return a.deadend_remoteness == remoteness)
	set_new_origin(options)
	
func move_origin_to_exit() -> void:
	var options = neighbors.keys()
	options.sort_custom(func(a, b): return a.deadend_remoteness < b.deadend_remoteness)
	options = options.filter(func(a): return a.deadend_remoteness == options[0].deadend_remoteness)
	
	#for option in options:
	#	print([option.grid, option.deadend_remoteness])
	set_new_origin(options)
	
func set_new_origin(options_: Array) -> void:
	if options_.size() == 1 and options_[0] == maze.previous_origin:
		roll_next_origin()
		return
	else:
		maze.origin = options_.pick_random()
		var trail = neighbors[maze.origin]
		
		if trail.is_active:
			trail.swap_windrose()
		else:
			trail.is_active = true
			var windrose = trail.crossroads[maze.origin]
			
			if windrose != trail.windrose:
				trail.swap_windrose()
		
		maze.previous_origin = self
		is_origin = false
		maze.origin.is_origin = true
		maze.origin.inactive_all_outputs()
		return
	
func get_manhattan_distance(crossroad_: CrossroadResource) -> int:
	return abs(grid.x - crossroad_.grid.x) + abs(grid.y - crossroad_.grid.y)
	
func roll_hazard() -> void:
	var description = Global.dict.crossroad.remoteness[deadend_remoteness]
	hazard = int(Global.get_random_key(description.hazard)) * 10 - 5
	
func roll_flock() -> FlockResource:
	var flock_resource = FlockResource.new()
	
	
	return flock_resource
