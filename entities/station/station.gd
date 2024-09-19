class_name Station extends ScrollContainer


@onready var route_scene = preload("res://entities/route/route.tscn")

var planet: Planet:
	set = set_planet
var resource: StationResource:
	set = set_resource


func set_planet(planet_: Planet) -> Station:
	planet = planet_
	init_routes()
	return self
	
func set_resource(resource_: StationResource) -> Station:
	resource = resource_
	return self
	
func init_routes() -> void:
	var route_resource = resource.routes.back()
	var route = route_scene.instantiate()
	route.set_resource(route_resource).set_station(self)
	
	#for crossroad in route_resource.crossroads:
	#	print(crossroad.index)
