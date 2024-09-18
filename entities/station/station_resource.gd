class_name StationResource extends Resource


var planet: PlanetResource:
	set = set_planet
var maze: MazeResource

var roots: Dictionary
var routes: Array[RouteResource]


func set_planet(planet_: PlanetResource) -> StationResource:
	planet = planet_
	maze = planet.maze
	init_roots()
	return self
	
func init_roots() -> void:
	var length = 1
	roots[length] = []
	
	for entrance in maze.entrances:
		roots[length].append([entrance])
	
	var flag = true
	
	while flag:
		flag = false
		length += 1
		roots[length] = []
		
		for root in roots[length - 1]:
			var crossroad = root.back()
			var trails = crossroad.trails.keys().filter(func(a): return a.is_active and !root.has(crossroad.trails[a]))
			
			if !trails.is_empty() and !flag:
				flag = true
			
			for trail in trails:
				var new_root = root.duplicate()
				var last_step = root.back().deadend_remoteness - root[root.size() - 2].deadend_remoteness
				var next_crossroad = crossroad.trails[trail]
				var next_step = next_crossroad.deadend_remoteness - root.back().deadend_remoteness
				
				if !(last_step < 0 and next_step > 0):
					new_root.append(crossroad.trails[trail])
					roots[length].append(new_root)
	
	for _length in roots:
		if _length > 1:
			for crossroads in roots[_length]:
				var end = crossroads.back()
				
				if end.trails.keys().filter(func(a): return a.is_active).size() == 1:
					var route = RouteResource.new()
					route.set_crossroads(crossroads).set_station(self)
