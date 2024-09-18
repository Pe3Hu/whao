class_name Flock extends PanelContainer


var route: Route:
	set = set_route
var resource: FlockResource:
	set = set_resource


func set_resource(resource_: FlockResource) -> Flock:
	resource = resource_
	return self
	
func set_route(route_: Route) -> Flock:
	route = route_
	route.get_node("%Milestones").add_child(self)
	return self
	
