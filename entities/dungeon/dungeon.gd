class_name Dungeon extends PanelContainer


var planet: Planet:
	set = set_planet
var resource: DungeonResource:
	set = set_resource
var index: int


func set_planet(planet_: Planet) -> Dungeon:
	planet = planet_
	index = planet.dungeons.get_child_count()
	planet.dungeons.add_child(self)
	return self
	
func set_resource(resource_: DungeonResource) -> Dungeon:
	resource = resource_
	return self
