class_name Recipe extends PanelContainer


@export var loot_scene = preload("res://entities/loot/loot.tscn")

@export var forge: Forge:
	set = set_forge
var resource: RecipeResource:
	set = set_resource


func set_forge(forge_: Forge) -> Recipe:
	forge = forge_
	#forge.get_node("%Recipes").add_child(self)
	return self
	
func set_resource(resource_: RecipeResource) -> Recipe:
	resource = resource_
	
	%Result.texture = load("res://entities/item/images/" + resource_.subtype + ".png")
	%Result.modulate = Global.color.rarity[resource_.rarity]
	%Level.text = str(resource_.level)
	init_ingredients()
	return self
	
func init_ingredients() -> void:
	for order in Global.arr.order:
		var ingredients = resource.get(order)
		var hbox = get_node("%" + order.capitalize())
		
		while hbox.get_child_count() > 0:
			var _loot = hbox.get_child(0)
			hbox.remove_child(_loot)
			_loot.queue_free()
		
		
		for type in ingredients:
			var loot = loot_scene.instantiate()
			hbox.add_child(loot)
			
			loot.type = type
			loot.rarity = resource.rarity
			#loot.level = resource.level
			loot.limit = ingredients[type]
