class_name Inventory extends Control


@export var member: Member

#var items_to_load := [
	#"res://entities/item/resources/chest.tres",
	#"res://entities/item/resources/dagger.tres",
	#"res://entities/item/resources/axe.tres"
#]


func _ready() -> void:
	for _i in 15:
		var slot := InventorySlot.new()
		var slot_resource = SlotResource.new()
		slot.init(self, slot_resource)
		%Grid.add_child(slot)
	
	#for _i in items_to_load.size():
		#var item = InventoryItem.new()
		#item.init(load(items_to_load[_i]))
		#%Grid.get_child(_i).add_child(item)
		
