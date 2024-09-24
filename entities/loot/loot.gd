@tool
class_name Loot extends TextureRect


@export_enum(
	"brain", "heart", "liver", 
	"paw", "jaw", 
	"skin", "bone", "blood", 
	"plant", "ore"
				) var type: String = "blood":
	set(type_):
		type = type_
		texture = load("res://entities/loot/images/" + type + ".png")
@export_enum("common", "uncommon", "rare", "epic", "legendary") var rarity: String = "common":
	set(rarity_):
		rarity = rarity_
		
		if is_node_ready():
			modulate = Global.color.rarity[rarity]
@export var level: int = 1:
	set(level_):
		level = level_
		%Level.text = str(level)
		%Level.visible = limit > 0
@export var current: int = 1:
	set(current_):
		current = current_
		%Current.text = str(current)
		#%Current.visible = limit > 0
@export var limit: int = 1:
	set(limit_):
		limit = limit_
		%Limit.text = str(limit)
		%Limit.visible = limit > 0
