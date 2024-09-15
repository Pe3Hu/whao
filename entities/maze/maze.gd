class_name Maze extends NinePatchRect


@export var crossroads: GridContainer
@export var trails: GridContainer

@onready var crossroad_scene = preload("res://entities/crossroad/crossroad.tscn")
@onready var trail_scene = preload("res://entities/trail/trail.tscn")

var planet: Planet:
	set = set_planet
var resource: MazeResource:
	set = set_resource


func set_planet(planet_: Planet) -> Maze:
	planet = planet_
	return self
	
func set_resource(resource_: MazeResource) -> Maze:
	resource = resource_
	
	custom_minimum_size = resource.total_size
	size = resource.total_size
	init_crossroads()
	return self
	
func init_crossroads() -> void:
	crossroads.columns = resource.cols
	crossroads.set("theme_override_constants/h_separation", resource.trail_size.x)
	crossroads.set("theme_override_constants/v_separation", resource.trail_size.y)
	
	for crossroad_resource in resource.crossroads:
		var crossroad = crossroad_scene.instantiate()
		crossroad.set_resource(crossroad_resource).set_maze(self)
	
	var a = crossroads.get_child_count()
	pass
