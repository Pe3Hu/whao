class_name RouteResource extends Resource


var station: StationResource:
	set = set_station
var crossroads: Array:
	set = set_crossroads
var milestones: Array[MilestoneResource]
var award: int


func set_station(station_: StationResource) -> RouteResource:
	station = station_
	station.routes.append(self)
	return self
	
func set_crossroads(crossroads_: Array) -> RouteResource:
	crossroads = crossroads_
	
	for crossroad in crossroads:
		var milestone = MilestoneResource.new()
		milestone.set_crossroad(crossroad).set_route(self)
	
	return self
