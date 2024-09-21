class_name Station extends ScrollContainer


@onready var route_scene = preload("res://entities/route/route.tscn")
@onready var totem_scene = preload("res://entities/totem/totem.tscn")

var planet: Planet:
	set = set_planet
var resource: StationResource:
	set = set_resource


func set_planet(planet_: Planet) -> Station:
	planet = planet_
	init_awards()
	init_routes()
	return self
	
func set_resource(resource_: StationResource) -> Station:
	resource = resource_
	return self
	
func init_awards() -> void:
	for beast in resource.awards:
		var totem = totem_scene.instantiate()
		%Awards.add_child(totem)
		totem.kind = beast
		totem.level = resource.awards[beast]
		var index = Global.arr.rarity.size() - resource.awards.keys().find(beast) - 1
		totem.rarity = Global.arr.rarity[index]
	
func init_routes() -> void:
	for route_resource in resource.routes:
		#var route_resource = resource.routes.front()
		var route = route_scene.instantiate()
		route.set_resource(route_resource).set_station(self)
	
	#for crossroad in route_resource.crossroads:
	#	print(crossroad.index)
