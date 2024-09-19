@tool
class_name Trail extends TextureRect


@export_enum("north", "east", "south", "west") var windrose: String = "south":
	set(windrose_):
		windrose = windrose_
		
		if is_node_ready():
			texture = load("res://entities/trail/images/line " + windrose + ".png")
			visible = resource.is_active
@export var value: int:
	set(value_):
		value = value_
		visible = value > 0
		
		if is_node_ready():
			weight.text = str(value)
	get:
		return value
@export var weight: Label

var maze: Maze:
	set = set_maze
var resource: TrailResource:
	set = set_resource


func set_resource(resource_: TrailResource) -> Trail:
	resource = resource_
	return self
	
func set_maze(maze_: Maze) -> Trail:
	maze = maze_
	maze.trails.add_child(self)
	position = resource.grid * maze.resource.trail_size * 2 - maze.resource.total_size / 2# + maze.resource.crossroad_size * 2 / 5
	windrose = resource.windrose
	return self
	
func update() -> void:
	windrose = resource.windrose
