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
		material = load("res://entities/loot/materials/" + type + ".tres")
		texture = load("res://entities/loot/images/" + type + ".png")
@export var value: int:
	set(value_):
		value = value_
		%Value.text = str(value)
	get:
		return value
