class_name Maze extends Control


@export var crossroads: GridContainer
@export var trails: Control

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
	init_trails()
	return self
	
func init_crossroads() -> void:
	crossroads.columns = resource.cols
	crossroads.set("theme_override_constants/h_separation", resource.trail_size.x)
	crossroads.set("theme_override_constants/v_separation", resource.trail_size.y)
	
	for crossroad_resource in resource.crossroads:
		var crossroad = crossroad_scene.instantiate()
		crossroad.set_resource(crossroad_resource).set_maze(self)
	
func init_trails() -> void:
	for trail_resource in resource.trails:
		var trail = trail_scene.instantiate()
		trail.set_resource(trail_resource).set_maze(self)
	
func roll_next_origin() -> void:
	var result = resource.origin.roll_next_origin()
	
	for trail in result.trails:
		trails.get_child(trail.index).update()
	
	for crossroad in result.crossroads:
		crossroads.get_child(crossroad.index).update()
	
func recalc_max_deadend_remoteness() -> void:
	resource.recalc_max_deadend_remoteness()
	
	for crossroad in crossroads.get_children():
		crossroad.update()
	
	for trail in trails.get_children():
		trail.update()
	
func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					recalc_max_deadend_remoteness()
