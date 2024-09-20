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
	
	add_leader()
	
	while current_hazard < limit_hazard:
		increase_hazard()
	
	#for level in eggs:
		#eggs[level].sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
	
	print(milestone.crossroad.hazard + milestone.crossroad.hazard_range, "_", current_hazard)
	while current_eggs > limit_eggs:
		swallow_an_egg()
	
	while current_hazard > milestone.crossroad.hazard + milestone.crossroad.hazard_range:
		balance_eggs()
	
	var levels = eggs.keys()
	levels.sort_custom(func(a, b): return a > b)
	var hazard_check = 0
	
	for level in levels:
		var rarities = eggs[level].keys()
		rarities.sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
		
		for rarity in rarities:
			hazard_check += eggs[level][rarity] * level * (Global.arr.rarity.find(rarity) + 1)
			print([level, rarity, eggs[level][rarity]])
	
	print([milestone.crossroad.deadend_remoteness, "_____", limit_hazard, current_hazard, hazard_check, current_eggs])
	
	if current_eggs > limit_eggs:
		print("fail")
		#print([egg.level, egg.rarity])
	
func add_leader() -> void:
	var hazard = ceil(limit_hazard / 2)
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
	#print([egg, hazard - hazard_shift, hazard, hazard + hazard_shift, _eggs])
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
	print(["swallow", egg])
	exchange_eggs(egg)
	
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
	
func exchange_eggs(egg_: Dictionary) -> void:
	current_eggs += egg_.count
	
	if egg_.count > 0:
		if !eggs.has(egg_.level):
			eggs[egg_.level] = {}
		
		if !eggs[egg_.level].has(egg_.rarity):
			eggs[egg_.level][egg_.rarity] = 0
	
	eggs[egg_.level][egg_.rarity] += egg_.count
	current_hazard += egg_.level * (Global.arr.rarity.find(egg_.rarity) + 1) * egg_.count
	
	if egg_.count < 0:
		if eggs[egg_.level][egg_.rarity] == 0:
			eggs[egg_.level].erase(egg_.rarity)
		
		if eggs[egg_.level].keys().is_empty:
			eggs.erase(egg_.level)
	
	print(current_hazard)
	
func balance_eggs() -> void:
	var egg
	
	egg = get_egg("best")
	egg.count = -1
	#if limit_hazard > current_hazard:
	#else:
		#egg = get_egg("worst")
		#egg.count = 1
	#
	exchange_eggs(egg)
	print(["balance -1", egg])
	
	if egg.rarity != Global.arr.rarity.front():
		var index = Global.arr.rarity.find(egg.rarity) - 1
		egg.rarity = Global.arr.rarity[index]
		egg.count = 1
		egg.erase("hazard")
		exchange_eggs(egg)
		print(["balance 1", egg])
	
	print([eggs])

#func swallow_an_egg() -> void:
	#print("swallow")
	#var donor = {}
	#donor.level = eggs.keys().front()
	#donor.rarity = eggs[donor.level].keys().front()
	#donor.repeat = eggs[donor.level][donor.rarity]
	#donor.count = 2
	#var recipient = {}
	#recipient.count = 1
	#
	#for level in eggs:
		#for rarity in eggs[level]:
			#if donor.repeat < eggs[level][rarity]:
				#donor.level = level
				#donor.rarity = rarity
				#donor.repeat = eggs[donor.level][donor.rarity]
	#
	#if donor.rarity != Global.arr.rarity.back() and donor.repeat > 1:
		#current_eggs -= 1
		#var index = Global.arr.rarity.find(donor.rarity) + 1
		#
		#if limit_hazard - current_hazard < 0:
			#if donor.rarity != Global.arr.rarity.front():
				#index = Global.arr.rarity.find(donor.rarity) - 1
			#else:
				#donor.count = 2
				#index = 0
		#
		#recipient.level = donor.level
		#recipient.rarity = Global.arr.rarity[index]
		#
		#exchange_eggs(donor, recipient)
	#else:
		#var options = []
		#
		#for level in eggs:
			#for rarity in eggs[level]:
				#if rarity != "legendary":
					#var option = {}
					#option.level = level
					#option.rarity = rarity
					#option.count = 1
					#options.append(option)
		#
		#donor = options.pick_random()
		#options.erase(donor)
		#recipient = options.pick_random()
	#
		#exchange_eggs(donor, recipient)
	#
#func balance_egg() -> void:
	#print("balance")
	#var balance = limit_hazard - current_hazard
	#
	#if eggs.has(abs(balance)):
		#var level = abs(balance)
		#var rarities = eggs[level].keys()
		#rarities.sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
		#
		#if rarities.size() > 1:
			#change_single_rarity(balance)
		#else:
			#var levels = eggs.keys().filter(func(a): return eggs[a].keys().size() > 1)
			#
			#if levels.is_empty():
				#eggs_balance_convergence(balance)
			#else:
				#level = levels.pick_random()
				#var _balance = sign(balance) * level
				#change_single_rarity(_balance)
	#else:
		#eggs_balance_convergence(balance)
		#
#func change_single_rarity(balance_: int) -> void:
	#print("change_single")
	#var level = abs(balance_)
	#var rarities = eggs[level].keys()
	#rarities.sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
	#
	#var donor = {}
	#var recipient = {}
	#var index
	#
	#if balance_ < 0:
		#donor.rarity = rarities.back()
		#index = Global.arr.rarity.find(donor.rarity) - 1
	#else:
		#donor.rarity = rarities.front()
		#index = Global.arr.rarity.find(donor.rarity) + 1
#
	#recipient.rarity = Global.arr.rarity[index]
	#recipient.level = level
	#donor.level = level
	#donor.count = 1
	#recipient.count = 1
	#exchange_eggs(donor, recipient)
	#
#func eggs_balance_convergence(balance_: int) -> void:
	#print("convergence")
	#var donor = {}
	#var recipient = {}
	#donor.count = 1
	#recipient.count = 1
	#
	#if eggs.keys().size() == 1:
		#shift_single_level(eggs.keys().front())
	#else:
		#var step = limit_hazard - current_hazard
		#var steps = {}
		#var levels = eggs.keys()
		#levels.sort()
		#
		#for _i in levels.size():
			#for _j in range(_i + 1, levels.size(), 1):
				#var _step = levels[_i] - levels[_j]
				#
				#if balance_ > 0:
					#var rarity_i = get_rarity("worst", eggs[levels[_i]].keys())
					#var rarity_j = get_rarity("best", eggs[levels[_j]].keys())
					#
					#if rarity_i != Global.arr.rarity.back() and rarity_j != Global.arr.rarity.front():
						#if !steps.has(_step):
							#steps[_step] = []
							#
						#steps[_step].append([levels[_i], levels[_j]])
				#else:
					#var rarity_i = get_rarity("best", eggs[levels[_i]].keys())
					#var rarity_j = get_rarity("worst", eggs[levels[_j]].keys())
					#
					#if rarity_j != Global.arr.rarity.back() and rarity_i != Global.arr.rarity.front():
						#if !steps.has(_step):
							#steps[_step] = []
						#
						#steps[_step].append([levels[_i], levels[_j]])
		#
		#if !steps.has(step):
			#var weights = {}
			#var max_shift = 0
			#
			#for _step in steps:
				#if max_shift < abs(_step - step):
					#max_shift = abs(_step - step)
			#
			#for _step in steps:
				#weights[_step] = (max_shift + 1) - abs(_step - step)
			#
			#step = Global.get_random_key(weights)
		#
		#if step == null:
			#shift_single_level(levels.front())
		#else:
			#var pair = steps[step].pick_random()
			#
			#if balance_ > 0:
				#donor.level = pair.back()
				#recipient.level = pair.front()
				#donor.rarity = get_rarity("worst", eggs[donor.level].keys())
				#recipient.rarity = get_rarity("best", eggs[recipient.level].keys())
			#else: 
				#donor.level = pair.front()
				#recipient.level = pair.back()
				#donor.rarity = get_rarity("best", eggs[donor.level].keys())
				#recipient.rarity = get_rarity("worst", eggs[recipient.level].keys())
		#
			#exchange_eggs(donor, recipient)
	#
#func get_rarity(extreme_: String, rarities_: Array) -> String:
	#rarities_.sort_custom(func(a, b): return Global.arr.rarity.find(a) > Global.arr.rarity.find(b))
	#var rarity
	#
	#match extreme_:
		#"best":
			#rarity = rarities_.front()
		#"worst":
			#rarity = rarities_.back()
	#
	#return rarity
	#
#func exchange_eggs(donor_: Dictionary, recipient_: Dictionary) -> void:
	#eggs[donor_.level][donor_.rarity] -= donor_.count
	#current_hazard -= donor_.level * (Global.arr.rarity.find(donor_.rarity) + 1) * donor_.count
	#
	#if eggs[donor_.level][donor_.rarity] == 0:
		#eggs[donor_.level].erase(donor_.rarity)
	#
	#if eggs[donor_.level].keys().is_empty:
		#eggs.erase(donor_.level)
	#
	#if !eggs.has(recipient_.level):
		#eggs[recipient_.level] = {}
	#
	#if !eggs[recipient_.level].has(recipient_.rarity):
		#eggs[recipient_.level][recipient_.rarity] = 0
	#
	#eggs[recipient_.level][recipient_.rarity] += recipient_.count
	#current_hazard += recipient_.level * (Global.arr.rarity.find(recipient_.rarity) + 1) * donor_.count
	#print(["exchange_eggs", limit_hazard, current_hazard, donor_, recipient_, current_eggs])
	#
#func shift_single_level(level_: int) -> void:
	#var donor = {}
	#var recipient = {}
	#donor.count = 1
	#recipient.count = 1
	#donor.level = level_
	#recipient.level = level_
	#
	#if limit_hazard - current_hazard < 0:
		#donor.rarity = get_rarity("worst", eggs[donor.level].keys()) 
		#var index = Global.arr.rarity.find(donor.rarity) + 1
		#recipient.rariry = Global.arr.rarity[index]
	#else:
		#donor.rarity = get_rarity("best", eggs[donor.level].keys()) 
		#var index = Global.arr.rarity.find(donor.rarity) - 1
		#recipient.rariry = Global.arr.rarity[index]
	#
	#exchange_eggs(donor, recipient)
