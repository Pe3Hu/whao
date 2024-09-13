class_name Planet extends PanelContainer


@export var world: World
@export var dungeons: VBoxContainer
@export var guilds: VBoxContainer

@onready var dungeon_scene = preload("res://entities/dungeon/dungeon.tscn")
@onready var guild_scene = preload("res://entities/guild/guild.tscn")

var resource: PlanetResource


func _ready() -> void:
	resource = PlanetResource.new()
	
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
