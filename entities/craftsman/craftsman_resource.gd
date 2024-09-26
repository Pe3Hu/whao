class_name CraftsmanResource extends Resource


var member: MemberResource:
	set = set_member
var forge: ForgeResource:
	set = set_forge
var recipes: Array[RecipeResource]


func set_member(member_: MemberResource) -> CraftsmanResource:
	member = member_
	forge = member.guild.planet.forge
	return self
	
func set_forge(forge_: ForgeResource) -> CraftsmanResource:
	forge = forge_
	forge.craftsmans.append(self)
	return self
	
func add_recipe(index_: int, level_: int, rarity_: String) -> void:
	var recipe
	
	if !forge.recipes.has(level_):
		forge.recipes[level_] = {}
		
	if !forge.recipes[level_].has(rarity_):
		forge.recipes[level_][rarity_] = {}
		
	if !forge.recipes[level_][rarity_].has(index_):
		recipe = RecipeResource.new()
		recipe.set_level(level_).set_rarity(rarity_).set_index(index_)
		forge.recipes[level_][rarity_][index_] = recipe
	else:
		recipe = forge.recipes[level_][index_]
	
	recipes.append(recipe)
	recipe.craftsmans.append(self)
	
func init_basic_recipe() -> void:
	var indexs = Global.dict.recipe.index.keys()#[0, 13]
	var level = 2
	var rarity = "uncommon"
	
	for index in indexs:
		add_recipe(index, level, rarity)
