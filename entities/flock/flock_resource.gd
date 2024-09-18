class_name FlockResource extends Resource


var route: RouteResource:
	set = set_route
var crossroad: CrossroadResource:
	set = set_crossroad
var hazard: int


func set_crossroad(crossroad_: CrossroadResource) -> FlockResource:
	crossroad = crossroad_
	return self

func set_route(route_: RouteResource) -> FlockResource:
	route = route_
	return self
