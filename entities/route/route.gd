class_name Route extends PanelContainer


@onready var milestone_scene = preload("res://entities/milestone/milestone.tscn")
@onready var flock_scene = preload("res://entities/flock/flock.tscn")

var station: Station:
	set = set_station
var resource: RouteResource:
	set = set_resource


func set_station(station_: Station) -> Route:
	station = station_
	station.get_node("%Routes").add_child(self)
	init_milestones()
	return self
	
func set_resource(resource_: RouteResource) -> Route:
	resource = resource_
	return self
	
func init_milestones() -> void:
	%Token.value = str(int(resource.award))
	
	for milestone_resource in resource.milestones:
		var milestone = milestone_scene.instantiate()
		milestone.set_resource(milestone_resource).set_route(self)
