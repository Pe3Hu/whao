class_name ForgeResource extends Resource


var planet: PlanetResource


func create_item() -> ItemResource:
	var item = ItemResource.new()
	item.type = "weapon"
	item.subtype = "dagger"
	item.rarity = "common"
	item.roll_primary()
	return item
