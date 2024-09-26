@tool
class_name InventorySlot extends PanelContainer


@export var inventory: Inventory
@export var resource: SlotResource
@export var kind: SlotResource.Kind:
	set(kind_):
		kind = kind_
		
		if is_node_ready():
			if kind != SlotResource.Kind.ANY:
				var key = SlotResource.Kind.keys()[kind]
				key = str(key).to_lower() 
				%BG.texture = load("res://entities/equipment/images/" + key + ".png")
			else:
				%BG.texture = null

func init(inventory_: Inventory, resource_: SlotResource) -> void:
	inventory = inventory_
	resource = resource_
	custom_minimum_size = resource_.cms
	
func _can_drop_data(_at_position: Vector2, item_: Variant) -> bool:
	if item_ is InventoryItem:
		if resource.type == SlotResource.Type.ANY:
			if get_child_count() == 0:
				return true
			else:
				if resource.type == item_.get_parent().type:
					return true
				else: get_child(0).resource.type == item_.resource.type
		else:
			return item_.resource.type == resource.type
	
	return false
	
func _drop_data(_at_position: Vector2, item_: Variant) -> void:
	var keys = ["damage", "defense"]
	
	if get_child_count() > 0:
		var item := get_child(0)
		
		if item == item_:
			return
		
		if resource.type != SlotResource.Type.ANY:
			for key in keys:
				inventory.gui.change_label(key, -item.resource.get(key))
		
		item.reparent(item_.get_parent())
	
	if item_.get_parent().type == resource.type and resource.type == SlotResource.Type.ANY:
		pass
	else:
		if resource.type != SlotResource.Type.ANY:
			for key in keys:
				inventory.gui.change_label(key, item_.resource.get(key))
		else:
			for key in keys:
				inventory.gui.change_label(key, -item_.resource.get(key))
	
	item_.reparent(self)
