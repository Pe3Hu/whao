class_name Flock extends PanelContainer


@onready var beast_scene = preload("res://entities/beast/beast.tscn")

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
	init_beasts()
	return self
	
func init_beasts() -> void:
	for beast_resouce in resource.beasts:
		var beast = beast_scene.instantiate()
		beast.set_resource(beast_resouce).set_flock(self)
