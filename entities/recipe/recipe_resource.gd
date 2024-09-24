class_name RecipeResource extends Resource


var level: int:
	set = set_level
var type: String
var subtype: String
var rarity: String
var title: String

var primary: Dictionary
var secondary: Dictionary
var craftsmans: Array[CraftsmanResource]


func set_index(index_: int) -> RecipeResource:
	var description = Global.dict.recipe.index[index_]
	
	for ingredient in description.ingredients:
		var ingredients
		
		for order in Global.arr.order:
			if Global.arr[order].has(ingredient):
				ingredients = get(order)
				break
		
		ingredients[ingredient] = description.ingredients[ingredient]
		
	for key in description:
		if key != "ingredients":
			set(key, description[key])
	
	init_title()
	return self
	
func set_level(level_: int) -> RecipeResource:
	level = level_
	return self
	
func set_rarity(rarity_: String) -> RecipeResource:
	rarity = rarity_
	return self
	
func init_title() -> void:
	title = rarity + " level " + str(level) + " " + subtype
	var weights = secondary.keys()
	weights.sort_custom(func(a,b): return secondary[a] > secondary[b])
	
	for shard in weights:
		title += " " + shard
