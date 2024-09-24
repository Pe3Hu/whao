class_name Craftsman extends PanelContainer


@export var forge: Forge:
	set = set_forge
var resource: CraftsmanResource:
	set = set_resource


func set_forge(forge_: Forge) -> Craftsman:
	forge = forge_
	#forge.get_node("%Craftsmans").add_child(self)
	return self
	
func set_resource(resource_: CraftsmanResource) -> Craftsman:
	resource = resource_
	init_recipes()
	return self
	
func init_recipes() -> void:
	%Recipes.clear()
	#while %Recipes.get_child_count() > 0:
		#var label = %Recipes.get_child(0)
		#%Recipes.remove_child(label)
		#label.queue_free()
	
	for recipe_resource in resource.recipes:
		%Recipes.add_item(recipe_resource.title)
		#var label = Label.new()
		#label.text = recipe_resource.title
		#%Recipes.add_child(label)
	
	%Recipes.select(0)
	_on_recipes_item_selected(0)


func _on_recipes_item_selected(index_: int) -> void:
	var recipe_resource = resource.recipes[index_]
	forge.get_node("%Recipe").set_resource(recipe_resource)
