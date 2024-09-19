class_name Flock extends PanelContainer


var milestone: Milestone:
	set = set_milestone
var resource: FlockResource:
	set = set_resource


func set_resource(resource_: FlockResource) -> Flock:
	resource = resource_
	return self
	
func set_milestone(milestone_: Milestone) -> Flock:
	milestone = milestone_
	milestone.get_node("%Flocks").add_child(self)
	return self
	
