class_name PlanetResource extends Resource


var maze: MazeResource
var dungeons: Array[DungeonResource]
var guilds: Array[GuildResource]


func _init() -> void:
	maze = MazeResource.new()
	maze.planet = self
	init_guilds()
	init_dungeons()
	prepare_dungeon()
	
func init_dungeons() -> void:
	var n = 1
	
	for _i in n:
		var dungeon = DungeonResource.new()
		dungeon.set_planet(self)
	
func init_guilds() -> void:
	var n = 1
	
	for _i in n:
		var guild = GuildResource.new()
		guild.set_planet(self)
	
func prepare_dungeon() -> void:
	pass
	#var dungeon = dungeons[0]
	#var guild = guilds[0]
	#guild.add_squad(dungeon)
