class_name Squad extends PanelContainer


var planet: Planet:
	set = set_planet
var resource: SquadResource:
	set = set_resource
var index: int


func set_planet(planet_: Planet) -> Squad:
	planet = planet_
	#index = planet.squads.get_child_count()
	#planet.squads.add_child(self)
	return self
	
func set_resource(resource_: SquadResource) -> Squad:
	resource = resource_
	return self
