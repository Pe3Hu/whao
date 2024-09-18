class_name RouteResource extends Resource


var station: StationResource:
	set = set_station
var crossroads: Array:
	set = set_crossroads


func set_station(station_: StationResource) -> RouteResource:
	station = station_
	station.routes.append(self)
	return self
	
func set_crossroads(crossroads_: Array) -> RouteResource:
	crossroads = crossroads_
	return self
