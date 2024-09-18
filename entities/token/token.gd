@tool
class_name Token extends TextureRect


@export_enum(
	"fury", "cunning", "wisdom", 
	"exploration", "extraction", 
	"fang", "claw", 
	"stamina", "experience"
				) var type: String = "fury":
	set(type_):
		type = type_
		material = load("res://entities/token/materials/" + type + ".tres")
		texture = load("res://entities/token/images/" + type + ".png")
@export var value: int:
	set(value_):
		value = value_
		%Value.text = str(value)
	get:
		return value
