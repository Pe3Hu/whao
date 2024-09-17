@tool
class_name Milestone extends TextureRect


@export var value: int:
	set(value_):
		value = value_
		%Value.text = str(value)
	get:
		return value
