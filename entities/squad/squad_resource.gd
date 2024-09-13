class_name SquadResource extends Resource


var planet: PlanetResource:
	set = set_planet
var members: Array[MemberResource]


func set_planet(planet_: PlanetResource) -> SquadResource:
	planet = planet_
	planet.squads.append(self)
	init_members()
	return self
	
func init_members() -> void:
	var n = 0
	
	#for aspect in Global.arr.aspect:
	for _i in n:
		var member = MemberResource.new()
		member.set_squad(self)#.set_aspect(aspect).set_squad(self)
