@tool
class_name Crossroad extends PanelContainer


@export_enum("origin", "not origin") var origin: String = "not origin":
	set(origin_):
		origin = origin_
		
		if is_node_ready():
			#%TextureRect.texture = load("res://entities/crossroad/images/" + origin + ".png")
			%TextureRect.modulate = Global.color.crossroad[origin]

var maze: Maze:
	set = set_maze
var resource: CrossroadResource:
	set = set_resource


func set_resource(resource_: CrossroadResource) -> Crossroad:
	resource = resource_
	return self
	
func set_maze(maze_: Maze) -> Crossroad:
	maze = maze_
	maze.crossroads.add_child(self)
	%TextureRect.texture = load("res://entities/crossroad/images/square.png")
	update()
	return self
	
func update() -> void:
	#%Remoteness.text = str(resource.deadend_remoteness)
	%Index.text = str(resource.index)
	if resource.terrain != "":
		%TextureRect.modulate = Global.color.terrain[resource.terrain]#Color.from_hsv(float(resource.deadend_remoteness + 1) / maze.resource.max_deadend_remoteness, 0.6, 0.7)
	#if resource.is_origin:
		#origin = "origin"
	#else:
		#origin = "not origin"
