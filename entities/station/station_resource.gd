class_name StationResource extends Resource


var planet: PlanetResource:
	set = set_planet
var maze: MazeResource

var roots: Dictionary
var routes: Array[RouteResource]
var awards: Dictionary


func set_planet(planet_: PlanetResource) -> StationResource:
	planet = planet_
	maze = planet.maze
	init_roots()
	init_awards()
	calc_routes_award()
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
	
func init_awards() -> void:
	var beasts = []
	var prizes = [8, 5, 3]
	var options = Global.dict.beast.title.keys()
	options.shuffle()
	
	while beasts.size() < prizes.size():
		var beast = options.pop_back()
		beasts.append(beast)
	
	for _i in beasts.size():
		awards[beasts[_i]] = prizes[_i]
	
func calc_routes_award() -> void:
	var weights = {}
	
	for terrain in Global.dict.terrain.beast:
		weights[terrain] = 0
		var shares = Global.dict.terrain.beast[terrain]
		var total = Global.dict.terrain.total[terrain]
		
		for beast in awards:
			if shares.has(beast):
				var share = float(shares[beast]) / total
				weights[terrain] += share * awards[beast]
	
	var terrains = weights.keys()
	terrains.sort_custom(func(a, b): return weights[a] > weights[b])
	
	for terrain in terrains:
		print([terrain, weights[terrain]])
	
	for route in routes:
		route.award = 0
		
		for milestone in route.milestones:
			route.award += weights[milestone.crossroad.terrain]
	
	routes.sort_custom(func(a, b): return a.award > b.award)
