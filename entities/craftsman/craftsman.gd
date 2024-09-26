class_name Craftsman extends PanelContainer


#@export var member: Member
#var resource: CraftsmanResource
#
#
#func init(member_: Member, resource_: CraftsmanResource) -> void:
	#member = member_
	#resource = resource_
	#init_recipes()
@export var member: Member:
	set = set_member
var resource: CraftsmanResource:
	set = set_resource


func set_member(member_: Member) -> Craftsman:
	member = member_
	return self
	
func set_resource(resource_: CraftsmanResource) -> Craftsman:
	resource = resource_
	init_recipes()
	return self
	
func init_recipes() -> void:
	%Recipes.clear()
	
	for recipe_resource in resource.recipes:
		%Recipes.add_item(recipe_resource.title)
	
	%Recipes.select(0)
	_on_recipes_item_selected(0)
	
func _on_recipes_item_selected(index_: int) -> void:
	var recipe_resource = resource.recipes[index_]
	%Recipe.set_resource(recipe_resource)
	#member.get_node("%Recipe").set_resource(recipe_resource)
