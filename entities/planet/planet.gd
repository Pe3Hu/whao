class_name Planet extends PanelContainer


@export var world: World
@export var dungeons: VBoxContainer
@export var guilds: VBoxContainer

@onready var dungeon_scene = preload("res://entities/dungeon/dungeon.tscn")
@onready var guild_scene = preload("res://entities/guild/guild.tscn")

var resource: PlanetResource


func _ready() -> void:
	resource = PlanetResource.new()
	%Maze.set_resource(resource.maze).set_planet(self)
	%Station.set_resource(resource.station).set_planet(self)
	
	#init_flock_combo()
	init_guilds()
	init_dungeons()
	
func init_guilds() -> void:
	for guild_resource in resource.guilds:
		var guild = guild_scene.instantiate()
		guild.set_resource(guild_resource).set_planet(self)
	
func init_dungeons() -> void:
	for dungeon_resource in resource.dungeons:
		var dungeon = dungeon_scene.instantiate()
		dungeon.set_resource(dungeon_resource).set_planet(self)
	
func init_flock_combo() -> void:
	var hazards = {}
	
	for level in range(1, 10, 1):
		for rarity in Global.arr.rarity:
			var hazard = level * (Global.arr.rarity.find(rarity) + 1)
			var egg = {}
			egg.level = level
			egg.rarity = rarity
			
			if !hazards.has(hazard):
				hazards[hazard] = []
			
			hazards[hazard].append(egg)
	
	var _hazards = hazards.keys()
	_hazards.sort()
	var combinations = {}
	
	for _a in range(0, _hazards.size(), 1):
		for _b in range(_a + 1, _hazards.size(), 1):
			for _c in range(_b + 1, _hazards.size(), 1):
				for _d in range(_c + 1, _hazards.size(), 1):
					for _e in range(_d + 1, _hazards.size(), 1):
						var combination = [_hazards[_a], _hazards[_b], _hazards[_c], _hazards[_d], _hazards[_e]]
						var sum = 0
						
						for hazard in combination:
							sum += hazard
						
						if !combinations.has(sum):
							combinations[sum] = []
						
						combinations[sum].append(combination)
	
	pass
