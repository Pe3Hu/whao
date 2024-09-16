class_name Item extends PanelContainer


var planet: Planet:
	set = set_planet
var resource: ItemResource:
	set = set_resource
var index: int


func set_planet(planet_: Planet) -> Item:
	planet = planet_
	planet.add_child(self)
	return self
	
func set_resource(resource_: ItemResource) -> Item:
	resource = resource_
	update_icons()
	return self
	
func update_icons() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Global.color.rarity[resource.rarity]
	set("theme_override_styles/panel", style)
	
	%Type.texture = load("res://entities/item/images/" + resource.subtype + ".png")
	%Primary.type = resource.primary
