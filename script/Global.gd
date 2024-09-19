extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	
func init_arr() -> void:
	arr.token = [
		"fury", "cunning", "wisdom", 
		"exploration", "extraction", 
		"fang", "claw", 
		"stamina", "experience"
	]
	arr.offense = ["fury", "cunning", "wisdom"]
	arr.support = ["exploration", "extraction"]
	arr.defense = ["fang", "claw"]
	arr.progression = ["stamina", "experience"]
	
	arr.rarity = ["common", "uncommon", "rare", "epic", "legendary"]
	
func init_num() -> void:
	num.index = {}
	
func init_dict() -> void:
	init_direction()
	init_corner()
	
	init_profession()
	init_item()
	init_crossroad()
	
func init_direction() -> void:
	dict.direction = {}
	dict.direction.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.direction.linear2 = [
		Vector2i( 0,-1),
		Vector2i( 1, 0),
		Vector2i( 0, 1),
		Vector2i(-1, 0)
	]
	dict.direction.diagonal = [
		Vector2i( 1,-1),
		Vector2i( 1, 1),
		Vector2i(-1, 1),
		Vector2i(-1,-1)
	]
	dict.direction.zero = [
		Vector2i( 0, 0),
		Vector2i( 1, 0),
		Vector2i( 1, 1),
		Vector2i( 0, 1)
	]
	dict.direction.hex = [
		[
			Vector2i( 1,-1), 
			Vector2i( 1, 0), 
			Vector2i( 0, 1), 
			Vector2i(-1, 0), 
			Vector2i(-1,-1),
			Vector2i( 0,-1)
		],
		[
			Vector2i( 1, 0),
			Vector2i( 1, 1),
			Vector2i( 0, 1),
			Vector2i(-1, 1),
			Vector2i(-1, 0),
			Vector2i( 0,-1)
		]
	]
	
	dict.direction.hybrid = []
	
	for _i in dict.direction.linear2.size():
		var direction = dict.direction.linear2[_i]
		dict.direction.hybrid.append(direction)
		direction = dict.direction.diagonal[_i]
		dict.direction.hybrid.append(direction)
	
	dict.reflect = {}
	var n = dict.direction.hybrid.size()
	
	for _i in n:
		var _j = (_i + n / 2) % n
		var origin_direction = dict.direction.hybrid[_i]
		var reflected_direction = dict.direction.hybrid[_j]
		dict.reflect[origin_direction] = reflected_direction
	
func init_corner() -> void:
	dict.order = {}
	dict.order.pair = {}
	dict.order.pair["even"] = "odd"
	dict.order.pair["odd"] = "even"
	var corners = [4]
	dict.corner = {}
	dict.corner.vector = {}
	
	for corners_ in corners:
		dict.corner.vector[corners_] = {}
		dict.corner.vector[corners_].even = {}
		
		for order_ in dict.order.pair.keys():
			dict.corner.vector[corners_][order_] = {}
		
			for _i in corners_:
				var angle = 2*PI*_i/corners_-PI/2
				
				if order_ == "odd":
					angle += PI/corners_
				
				var vertex = Vector2(1,0).rotated(angle)
				dict.corner.vector[corners_][order_][_i] = vertex
	
func init_profession() -> void:
	dict.profession = {}
	dict.profession.title = {}
	dict.profession.race = {}
	var exceptions = ["title", "race"]
	
	var path = "res://entities/member/profession.json"
	var array = load_data(path)
	
	for profession in array:
		var data = {}
		data.race = profession.race
		
		for key in profession:
			if !exceptions.has(key):
				var words = key.split(" ")
				
				if !data.has(words[0]):
					data[words[0]] = {}
				
				data[words[0]][words[1]] = profession[key]
	
		if !dict.profession.race.has(profession.race):
			dict.profession.race[profession.race] = []
		
		dict.profession.race[profession.race].append(profession.title)
		dict.profession.title[profession.title] = data
	
func init_crossroad() -> void:
	dict.crossroad = {}
	dict.crossroad.remoteness = {}
	var exceptions = ["remoteness"]
	
	var path = "res://entities/crossroad/crossroad.json"
	var array = load_data(path)
	
	for crossroad in array:
		crossroad.remoteness = int(crossroad.remoteness)
		var data = {}
		
		for key in crossroad:
			if !exceptions.has(key):
				var words = key.split(" ")
				
				if !data.has(words[0]):
					data[words[0]] = {}
				
				if words[0] != "rarity":
					data[words[0]][int(words[1])] = int(crossroad[key])
				else:
					data[words[0]][words[1]] = int(crossroad[key])
		
		dict.crossroad.remoteness[crossroad.remoteness] = data
	
func init_item() -> void:
	dict.item = {}
	dict.item.title = {}
	dict.item.type = {}
	var exceptions = ["title"]
	
	var path = "res://entities/item/item.json"
	var array = load_data(path)
	
	for item in array:
		var data = {}
		data.affixs = {}
		
		for key in item:
			if !exceptions.has(key):
				var words = key.split(" ")
				
				if words.size() > 1:
					match words[0]:
						"affix":
							data.affixs[item[key]] = -1
						"weight":
							var affix = data.affixs.keys()[int(words[1])]
							data.affixs[affix] = item[key]
				else:
					data[key] = item[key]
	
		if !dict.item.type.has(item.type):
			dict.item.type[item.type] = []
		
		dict.item.type[item.type].append(item.title)
		dict.item.title[item.title] = data
	
func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	
	init_window_size()
	
func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)
	
func init_color():
	var h = 360.0
	
	color.rarity = {}
	#color.rarity["ordinary"] = Color.from_hsv(210 / h, 0.5, 0.2)
	color.rarity["common"] = Color.from_hsv(210 / h, 0.2, 0.6)
	#color.rarity["unusual"] = Color.from_hsv(140 / h, 0.8, 0.3)
	color.rarity["uncommon"] = Color.from_hsv(140 / h, 0.9, 0.6)
	#color.rarity["rare"] = Color.from_hsv(210 / h, 0.9, 0.3)
	color.rarity["rare"] = Color.from_hsv(210 / h, 0.9, 0.6)
	#color.rarity["epic"] = Color.from_hsv(300 / h, 0.7, 0.4)
	color.rarity["epic"] = Color.from_hsv(300 / h, 0.9, 0.6)
	#color.rarity["legendary"] = Color.from_hsv(50 / h, 0.8, 0.5)
	color.rarity["legendary"] = Color.from_hsv(60 / h, 0.9, 0.8)
	
	color.terrain = {}
	color.terrain["desert"] = Color.from_hsv(60 / h, 0.8, 0.8)
	color.terrain["jungle"] = Color.from_hsv(130 / h, 0.9, 0.7)
	color.terrain["swamp"] = Color.from_hsv(90 / h, 0.8, 0.4)
	color.terrain["plain"] = Color.from_hsv(80 / h, 0.7, 0.7)
	color.terrain["mountain"] = Color.from_hsv(180 / h, 0.3, 0.6)
	color.terrain["tundra"] = Color.from_hsv(230 / h, 0.4, 0.6)
	
	color.totem = {}
	color.totem["cougar"] = Color.from_hsv(30 / h, 0.9, 0.6)
	color.totem["bear"] = Color.from_hsv(0 / h, 0.9, 0.6)
	color.totem["wolf"] = Color.from_hsv(330 / h, 0.9, 0.6)
	color.totem["turtle"] = Color.from_hsv(90 / h, 0.9, 0.6)
	color.totem["cobra"] = Color.from_hsv(120 / h, 0.9, 0.6)
	color.totem["crocodile"] = Color.from_hsv(150 / h, 0.9, 0.6)
	color.totem["raven"] = Color.from_hsv(195 / h, 0.9, 0.6)
	color.totem["owl"] = Color.from_hsv(210 / h, 0.9, 0.6)
	color.totem["hawk"] = Color.from_hsv(225 / h, 0.9, 0.6)
	
func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)
	
func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()
	
func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
