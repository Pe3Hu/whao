class_name EquipmentResource extends Resource


#enum type {weapon, armor, jewellry}
#enum weapon_subtype {none, dagger, axe, hammer, staff, bow, rifle}
#enum jewellry_subtype {none, necklace, ring, earring}
#enum armor_subtype {none, helmet, chest, gloves, pants, boots}

var type: String
var subtype: String
var rarity: String
var primary: String


func roll_primary() -> void:
	var description = Global.dict.item.title[subtype]
	var options = Global.arr[description.primary]
	primary = options.pick_random()
