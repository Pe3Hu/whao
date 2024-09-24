class_name Forge extends PanelContainer


#@onready var recipe_scene = preload("res://entities/recipe/recipe.tscn")

var planet: Planet:
	set = set_planet
var resource: ForgeResource:
	set = set_resource


func set_planet(planet_: Planet) -> Forge:
	planet = planet_
	select_craftsman()
	return self
	
func set_resource(resource_: ForgeResource) -> Forge:
	resource = resource_
	return self
	
func select_craftsman() -> void:
	var craftsman_resource = resource.craftsmans.front()
	%Craftsman.set_resource(craftsman_resource)
	
func set_craftsman() -> void:
	#%Recipe.set_resource(recipe_resource).set_forge(self)
	pass
