class_name TrailResource extends Resource


var maze: MazeResource:
	set = set_maze
var grid: Vector2i:
	set = set_grid

var total_size: Vector2 = Vector2(96, 96)


func set_grid(grid_: Vector2i) -> TrailResource:
	grid = grid_
	return self
	
func set_maze(maze_: MazeResource) -> TrailResource:
	maze = maze_
	maze.trails.append(self)
	maze.grids.trails[grid] = self
	return self
