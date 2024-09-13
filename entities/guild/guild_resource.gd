class_name GuildResource extends Resource


var planet: PlanetResource:
	set = set_planet
var members: Array[MemberResource]


func set_planet(planet_: PlanetResource) -> GuildResource:
	planet = planet_
	planet.guilds.append(self)
	init_members()
	return self
	
func init_members() -> void:
	for profession in Global.dict.profession.title:
		var member = MemberResource.new()
		member.set_profession(profession).set_guild(self)
