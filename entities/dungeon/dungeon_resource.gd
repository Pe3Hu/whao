class_name DungeonResource extends Resource


var planet: PlanetResource:
	set = set_planet
var guild: GuildResource:
	set = set_guild


func set_guild(guild_: GuildResource) -> DungeonResource:
	guild = guild_
	return self
	
func set_planet(planet_: PlanetResource) -> DungeonResource:
	planet = planet_
	planet.dungeons.append(self)
	return self
