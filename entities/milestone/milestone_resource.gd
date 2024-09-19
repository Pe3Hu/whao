class_name MilestoneResource extends Resource


var route: RouteResource:
	set = set_route
var crossroad: CrossroadResource:
	set = set_crossroad

var flocks: Array[FlockResource]


func set_route(route_: RouteResource) -> MilestoneResource:
	route = route_
	route.milestones.append(self)
	return self
	
func set_crossroad(crossroad_: CrossroadResource) -> MilestoneResource:
	crossroad = crossroad_
	return self
	
func add_flock() -> void:
	var flock_resource = FlockResource.new()
	flock_resource.set_milestone(self)
