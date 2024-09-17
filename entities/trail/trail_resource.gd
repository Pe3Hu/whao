class_name TrailResource extends Resource


var maze: MazeResource:
	set = set_maze
var grid: Vector2:
	set = set_grid
var crossroads: Dictionary
var windroses: Dictionary
var orientation: String
var windrose: String
var is_active: bool = true
var index: int


func set_grid(grid_: Vector2) -> TrailResource:
	grid = grid_
	return self
	
func set_maze(maze_: MazeResource) -> TrailResource:
	maze = maze_
	index = maze.trails.size()
	maze.trails.append(self)
	maze.grids[grid] = self
	init_crossroads()
	return self
	
func init_crossroads() -> void:
	var _grid = grid * 2
	var shifts
	
	if int(_grid.x) % 2 == 1:
		orientation = "horizontal"
		shifts = [Vector2(-0.5, 0), Vector2(0.5, 0)]
		windrose = "east"
	
	if int(_grid.y) % 2 == 1:
		orientation = "vertical"
		shifts = [Vector2(0, -0.5), Vector2(0, 0.5)]
		windrose = "south"
		is_active = grid.x == maze.cols - 1
	
	for _i in shifts.size():
		var _windrose = maze[orientation][_i]
		var crossroad_grid = grid + shifts[_i]
		var crossroad = maze.grids[crossroad_grid]
		crossroads[crossroad] = _windrose
		windroses[_windrose] = crossroad
		
		var _j = (_i + 1) % shifts.size()
		var neighbor_grid = grid + shifts[_j]
		var crossroad_neighbor = maze.grids[neighbor_grid]
		crossroad.trails[self] = crossroad_neighbor
		crossroad_neighbor.trails[self] = crossroad
		crossroad.neighbors[crossroad_neighbor] = self
		crossroad_neighbor.neighbors[crossroad] = self
	
func get_another_crossroad(crossroad_: CrossroadResource) -> Variant:
	if crossroads.keys().has(crossroad_):
		if crossroads.keys().front() == crossroad_:
			return crossroads.keys().back()
		else:
			return crossroads.keys().front()
	
	return null
	
func swap_windrose() -> void:
	var crossroad_input = windroses[windrose]
	var crossroad_output = get_another_crossroad(crossroad_input)
	crossroad_input.inputs.erase(self)
	crossroad_output.outputs.erase(self)
	var _index = (maze[orientation].find(windrose) + 1) % maze[orientation].size()
	windrose = maze[orientation][_index]
	crossroad_input.outputs.append(self)
	crossroad_output.inputs.append(self)
