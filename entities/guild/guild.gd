class_name Guild extends PanelContainer


@export var members: GridContainer

@onready var member_scene = preload("res://entities/member/member.tscn")

var planet: Planet:
	set = set_planet
var resource: GuildResource:
	set = set_resource
var index: int


func set_planet(planet_: Planet) -> Guild:
	planet = planet_
	index = planet.guilds.get_child_count()
	planet.guilds.add_child(self)
	init_members()
	return self
	
func set_resource(resource_: GuildResource) -> Guild:
	resource = resource_
	return self
	
func init_members() -> void:
	for member_resource in resource.members:
		var member = member_scene.instantiate()
		member.set_resource(member_resource).set_guild(self)
