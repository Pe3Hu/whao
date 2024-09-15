class_name CrossroadResource extends Resource


var maze: MazeResource:
	set = set_maze
var grid: Vector2i:
	set = set_grid

var arrow_size: Vector2 = Vector2(32, 32)


func set_grid(grid_: Vector2i) -> CrossroadResource:
	grid = grid_
	return self
	
func set_maze(maze_: MazeResource) -> CrossroadResource:
	maze = maze_
	maze.crossroads.append(self)
	maze.grids.crossroad[grid] = self
	return self
