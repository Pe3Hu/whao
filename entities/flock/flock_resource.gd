class_name FlockResource extends Resource


var milestone: MilestoneResource:
	set = set_milestone
var beasts: Array[BeastResource]

var eggs: Dictionary
var limit_hazard: int
var current_hazard: int
var current_eggs: int = 0

const limit_eggs = 5 


func set_milestone(milestone_: MilestoneResource) -> FlockResource:
	milestone = milestone_
	milestone.flocks.append(self)
	roll_hazard()
	return self
	
func roll_hazard() -> void:
	limit_hazard = randi_range(milestone.crossroad.hazard - milestone.crossroad.hazard_range, milestone.crossroad.hazard + milestone.crossroad.hazard_range)
	init_beast()
	
func init_beast() -> void:
	fill_eggs()
	
	var levels = eggs.keys()
	levels.sort_custom(func(a, b): return a > b)
	
	for level in levels:
		var rarities = eggs[level].keys()
		rarities.sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
		
		for rarity in rarities:
			var beast_resource = BeastResource.new()
			beast_resource.level = level
			beast_resource.rarity = rarity
			beast_resource.kind = Global.get_random_key(Global.dict.terrain.title[milestone.crossroad.terrain])
			beast_resource.flock = self
	
func fill_eggs() -> void:
	#if milestone.route.milestones.find(milestone) == 1:
	
	add_leader()
	
	while current_hazard < limit_hazard:
		increase_hazard()
	
	#for level in eggs:
		#eggs[level].sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
	#milestone.crossroad.hazard + milestone.crossroad.hazard_range
	while current_eggs > limit_eggs:
		swallow_an_egg()
	
	while current_hazard > limit_hazard:
		balance_eggs()
	
	expand_eggs()
	#print(["before", limit_hazard - current_hazard, limit_hazard, current_hazard])
	#print(eggs)
	var flag_shift = different_shift()
	
	while flag_shift:
		flag_shift = different_shift()
	
	flag_shift = equal_shift()
	
	while flag_shift:
		flag_shift = equal_shift()
	
	#print(["after", limit_hazard - current_hazard, limit_hazard, current_hazard])
	#print(eggs)
	#var levels = eggs.keys()
	#levels.sort_custom(func(a, b): return a > b)
	#
	#for level in levels:
		#var rarities = eggs[level].keys()
		#rarities.sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
		#
		#for rarity in rarities:
			#print([level, rarity, eggs[level][rarity]])
	
	if current_eggs > limit_eggs:
		print("fail limit_eggs")
	
	if limit_hazard != current_hazard:
		limit_hazard = current_hazard
		#print([milestone.crossroad.deadend_remoteness, "fail hazard", current_hazard, limit_hazard, eggs])
	
func add_leader() -> void:
	var hazard = ceil(int(limit_hazard / 2))
	hazard += limit_hazard % 2
	
	var egg_size = 3
	var _eggs = []
	var hazard_shift = 1
	
	if Global.dict.egg.hazard.has(hazard):
		_eggs = Global.dict.egg.hazard[hazard].filter(func (a): return abs(a.level - milestone.crossroad.deadend_remoteness) <= 2)
	
	while _eggs.size() < egg_size:
		var options = []
		
		for shift in range(-hazard_shift, hazard_shift + 1, hazard_shift * 2):
			var option = hazard + shift
			
			if Global.dict.egg.hazard.has(option):
				options.append(option)
		
		hazard_shift += 1
		options.sort()
		
		while !options.is_empty() and _eggs.size() < egg_size:
			var option = options.pop_back()
			_eggs.append_array(Global.dict.egg.hazard[option].filter(func (a): return abs(a.level - milestone.crossroad.deadend_remoteness) <= 2))
	
	hazard_shift -= 1
	var egg = _eggs.pick_random()
	eggs[egg.level] = {}
	eggs[egg.level][egg.rarity] = 1
	current_eggs += 1
	current_hazard += egg.level * (Global.arr.rarity.find(egg.rarity) + 1)
	
func increase_hazard() -> void:
	var remoteness = milestone.crossroad.deadend_remoteness
	var description = Global.dict.crossroad.remoteness[remoteness]
	var egg = {}
	egg.level = Global.get_random_key(description.level) + remoteness
	egg.rarity = Global.get_random_key(description.rarity)
	
	if !eggs.has(egg.level):
		eggs[egg.level] = {}
		
	if !eggs[egg.level].has(egg.rarity):
		eggs[egg.level][egg.rarity] = 0

	eggs[egg.level][egg.rarity] += 1
	current_eggs += 1
	current_hazard += egg.level * (Global.arr.rarity.find(egg.rarity) + 1)
	
func swallow_an_egg() -> void:
	var egg = get_egg("worst")
	egg.count = -1
	change_eggs(egg)
	
func get_egg(extreme_: String) -> Dictionary:
	var hazards = []
	
	for level in eggs:
		for rarity in eggs[level]:
			var egg = {}
			egg.level = level
			egg.rarity = rarity
			egg.hazard = level * (Global.arr.rarity.find(rarity) + 1)
			hazards.append(egg)
	
	match extreme_:
		"best":
			hazards.sort_custom(func (a,b): return a.hazard < b.hazard)
		"worst":
			hazards.sort_custom(func (a,b): return a.hazard > b.hazard)
	
	var options = hazards.filter(func (a): return a.hazard == hazards.back().hazard)
	return options.pick_random()
	
func change_eggs(egg_: Dictionary) -> void:
	current_eggs += egg_.count
	
	if egg_.count > 0:
		if !eggs.has(egg_.level):
			eggs[egg_.level] = {}
		
		if !eggs[egg_.level].has(egg_.rarity):
			eggs[egg_.level][egg_.rarity] = 0
	
	eggs[egg_.level][egg_.rarity] += egg_.count
	current_hazard += egg_.level * (Global.arr.rarity.find(egg_.rarity) + 1) * egg_.count
	
	if egg_.count < 0:
		if eggs[egg_.level][egg_.rarity] <= 0:
			eggs[egg_.level].erase(egg_.rarity)
		
		if eggs[egg_.level].keys().size() == 0:
			eggs.erase(egg_.level)
	
func balance_eggs() -> void:
	var egg = get_egg("best")
	egg.count = -1
	change_eggs(egg)
	egg.count = 1
	egg.erase("hazard")
	
	if Global.dict.rarity.previous.has(egg.rarity):
		egg.rarity = Global.dict.rarity.previous[egg.rarity]
	else:
		egg.level = egg.level - 1
	
	if egg.level > 0:
		change_eggs(egg)
	
func different_shift() -> bool:
	if limit_hazard - current_hazard == 0:
		return false
	
	var level_gaps = {}
	
	for min_level in eggs:
		for max_level in range(min_level + 1, 10, 1):
			if eggs.has(max_level):
				var level_gap = max_level - min_level
				
				if abs(limit_hazard - current_hazard) >= level_gap:
					var gap = {}
					gap.min = {}
					gap.min.level = min_level
					gap.min.rarities = eggs[min_level].keys().filter(func (a): return Global.dict.rarity.previous.has(a))
					gap.max = {}
					gap.max.level = max_level
					gap.max.rarities = eggs[max_level].keys().filter(func (a): return Global.dict.rarity.next.has(a))
					
					if !gap.min.rarities.is_empty() and !gap.max.rarities.is_empty():
						gap.min.rarities.sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
						gap.max.rarities.sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
						
						if !level_gaps.has(level_gap):
							level_gaps[level_gap] = []
						
						level_gaps[level_gap].append(gap)
	
	if level_gaps.keys().is_empty():
		return false
	else:
		var gaps = level_gaps.keys()
		gaps.sort()
		var level_gap = gaps.back()
		var gap = level_gaps[level_gap].pick_random()
		#print(limit_hazard - current_hazard, gap)
		var egg = {}
		egg.level = gap.min.level
		egg.rarity = gap.min.rarities.back()#.pick_random()
		swap_egg_rarity("previous", egg)
		egg.level = gap.max.level
		egg.rarity = gap.max.rarities.front()
		swap_egg_rarity("next", egg)
		
		#egg.rarity = gap.min.rarities.back()#.pick_random()
		#egg.count = -1
		#change_eggs(egg)
		#
		#egg.level = gap.max.level
		#gap.max.rarities.sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
		#egg.rarity = gap.max.rarities.front()#.pick_random()
		#change_eggs(egg)
		#
		#egg.rarity = Global.dict.rarity.next[egg.rarity]
		#egg.count = 1
		#change_eggs(egg)
		#
		#egg.level = gap.min.level
		#egg.rarity = Global.dict.rarity.previous[egg.rarity]
		#change_eggs(egg)
		
		return true
	
func equal_shift() -> bool:
	if limit_hazard - current_hazard == 0:
		return false
	
	var level_gaps = {}
	
	for min_level in eggs:
		for max_level in range(min_level + 1, 10, 1):
			if eggs.has(max_level):
				var level_gap = max_level - min_level
				
				if abs(limit_hazard - current_hazard) >= level_gap:
					var gap = {}
					gap.min = {}
					gap.min.level = min_level
					gap.min.rarities = eggs[min_level].keys()
					gap.max = {}
					gap.max.level = max_level
					gap.max.rarities = eggs[max_level].keys().filter(func (a): return gap.min.rarities.has(a))
					
					if !gap.min.rarities.is_empty() and !gap.max.rarities.is_empty():
						if !level_gaps.has(level_gap):
							level_gaps[level_gap] = []
						
						level_gaps[level_gap].append(gap)
	
	if level_gaps.keys().is_empty():
		return false
	else:
		var gaps = level_gaps.keys()
		gaps.sort()
		var level_gap = gaps.back()
		var gap = level_gaps[level_gap].pick_random()
		var rarity = gap.max.rarities.pick_random()
		swap_equal_rarity(rarity, gap.min.level, gap.max.level)
		#print(limit_hazard - current_hazard, gap)
		return true
	
func swap_egg_rarity(order_: String, egg_: Dictionary) -> void:
	egg_.count = -1
	change_eggs(egg_)
	egg_.count = 1
	egg_.rarity = Global.dict.rarity[order_][egg_.rarity]
	change_eggs(egg_)
	
func swap_equal_rarity(rarity_: String, min_level_: int, max_level_: int) -> void:
	var egg = {}
	egg.level = min_level_
	egg.rarity = rarity_
	egg.count = -1
	change_eggs(egg)
	egg.level = max_level_
	egg.count = 1
	change_eggs(egg)
	
func expand_eggs() -> void:
	if limit_hazard > current_hazard and current_eggs < limit_eggs:
		var hazard_gap = limit_hazard - current_hazard
		var egg = {}
		egg.rarity = "common"
		egg.count = 1
		egg.gap = INF
		
		for _i in range(-2, 3, 1):
			var level = milestone.crossroad.deadend_remoteness + _i
			var gap = abs(level - hazard_gap)
			
			if egg.gap > gap and hazard_gap >= level:
				egg.gap = gap
				egg.level = level
		
		if egg.has("level"):
			change_eggs(egg)
