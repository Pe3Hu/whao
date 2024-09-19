@tool
class_name Totem extends TextureRect


@export_enum("owl", "raven", "hawk", "bear", "cougar", "wolf", "turtle", "crocodile", "cobra") var title: String = "bear":
	set(title_):
		title = title_
		texture = load("res://entities/totem/images/" + title + ".png")
		
		if is_node_ready():
			modulate = Global.color.totem[title]
	get:
		return title
@export var level: int = 1:
	set(level_):
		level = level_
		%Level.text = str(level)
	get:
		return level
