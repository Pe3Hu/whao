class_name FlockResource extends Resource


var milestone: MilestoneResource:
	set = set_milestone

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
	fill_beasts()
	
func fill_beasts() -> void:
	#print(limit_hazard)
	#if milestone.route.milestones.find(milestone) == 1:
	
	while current_hazard < limit_hazard:
		increase_hazard()
	
	#for level in eggs:
		#eggs[level].sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
	
	while current_eggs > limit_eggs or current_hazard > limit_hazard:
		swallow_an_egg()
	
	var levels = eggs.keys()
	levels.sort_custom(func(a, b): return a > b)
	var hazard_check = 0
	
	for level in levels:
		var rarities = eggs[level].keys()
		rarities.sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
		
		for rarity in rarities:
			hazard_check += eggs[level][rarity] * level * (Global.arr.rarity.find(rarity) + 1)
			print([level, rarity, eggs[level][rarity]])
	print([limit_hazard, current_hazard, hazard_check, current_eggs])
		#print([egg.level, egg.rarity])
	
	
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
	current_hazard -= 1
	
	if current_eggs > limit_eggs:
		var popular_egg = {}
		popular_egg.level = eggs.keys().front()
		popular_egg.rarity = eggs[popular_egg.level].keys().front()
		popular_egg.repeat = eggs[popular_egg.level][popular_egg.rarity]
		
		for level in eggs:
			for rarity in eggs[level]:
				if popular_egg.repeat < eggs[level][rarity]:
					popular_egg.level = level
					popular_egg.rarity = rarity
					popular_egg.repeat = eggs[popular_egg.level][popular_egg.rarity]
		
		current_eggs -= 1
		
		if popular_egg.repeat > 1:
			eggs[popular_egg.level][popular_egg.rarity] -= 2
			current_hazard -= popular_egg.level * (Global.arr.rarity.find(popular_egg.rarity) + 1) * 2
			var index = Global.arr.rarity.find(popular_egg.rarity) + 1
			var rarity = Global.arr.rarity[index]
			
			if !eggs[popular_egg.level].has(rarity):
				eggs[popular_egg.level][rarity] = 0
			
			eggs[popular_egg.level][rarity] += 1
			current_hazard += popular_egg.level * (Global.arr.rarity.find(rarity) + 1)
			
			if eggs[popular_egg.level][popular_egg.rarity] == 0:
				eggs[popular_egg.level].erase(popular_egg.rarity)
				
			#if eggs[popular_egg.level].keys().is_empty:
			#	eggs.erase(popular_egg.level)
