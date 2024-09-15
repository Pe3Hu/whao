class_name Crossroad extends TextureRect


var maze: Maze:
	set = set_maze
var resource: CrossroadResource:
	set = set_resource

var is_origin: bool:
	set(is_origin_):
		is_origin = is_origin_


func set_resource(resource_: CrossroadResource) -> Crossroad:
	resource = resource_
	return self
	
func set_maze(maze_: Maze) -> Crossroad:
	maze = maze_
	maze.crossroads.add_child(self)
	return self
