class_name ForgeResource extends Resource


var planet: PlanetResource
var craftsmans: Array[CraftsmanResource]
var recipes: Dictionary


func _init() -> void:
	var member = MemberResource.new()
	add_craftsman(member)
	var indexs = Global.dict.recipe.index.keys()#[0, 13]
	var level = 2
	var rarity = "uncommon"
	
	for index in indexs:
		craftsmans[0].add_recipe(index, level, rarity)

func add_craftsman(member_: MemberResource) -> void:
	var craftsman = CraftsmanResource.new()
	craftsman.set_member(member_).set_forge(self)

func create_item() -> ItemResource:
	var item = ItemResource.new()
	item.type = "weapon"
	item.subtype = "dagger"
	item.rarity = "common"
	item.roll_primary()
	return item
