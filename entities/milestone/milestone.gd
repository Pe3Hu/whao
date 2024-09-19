@tool
class_name Milestone extends PanelContainer


@export_enum("desert", "jungle", "swamp", "plain", "mountain", "tundra") var terrain: String = "desert":
	set(terrain_):
		terrain = terrain_
		%Crossroad.modulate = Global.color.terrain[terrain]
	get:
		return terrain
@export var hazard: int:
	set(hazard_):
		hazard = hazard_
		%Hazard.text = str(hazard)
	get:
		return hazard

@onready var flock_scene = preload("res://entities/flock/flock.tscn")

var route: Route:
	set = set_route
var resource: MilestoneResource:
	set = set_resource


func set_route(route_: Route) -> Milestone:
	route = route_
	route.get_node("%Milestones").add_child(self)
	
	hazard = resource.crossroad.hazard
	terrain = resource.crossroad.terrain
	add_flock()
	return self
	
func set_resource(resource_: MilestoneResource) -> Milestone:
	resource = resource_
	return self
	
func add_flock() -> void:
	resource.add_flock()
	var flock_resource = resource.flocks.back()
	var flock = flock_scene.instantiate()
	flock.set_resource(flock_resource).set_milestone(self)
