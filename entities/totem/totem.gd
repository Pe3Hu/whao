@tool
class_name Totem extends TextureRect


@export_enum("owl", "raven", "hawk", "bear", "cougar", "wolf", "turtle", "crocodile", "cobra") var kind: String = "bear":
	set(kind_):
		kind = kind_
		texture = load("res://entities/totem/images/" + kind + ".png")
		
		#if is_node_ready():
		#	modulate = Global.color.totem[kind]
	get:
		return kind
@export_enum("common", "uncommon", "rare", "epic", "legendary") var rarity: String = "common":
	set(rarity_):
		rarity = rarity_
		
		if is_node_ready():
			modulate = Global.color.rarity[rarity]
	get:
		return rarity
@export var level: int = 1:
	set(level_):
		level = level_
		%Level.text = str(level)
	get:
		return level
