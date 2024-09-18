@tool
class_name Milestone extends TextureRect


@export var terrain: String:
	set(terrain_):
		terrain = terrain_
		modulate = Global.color.terrain[terrain]
	get:
		return terrain
@export var hazard: int:
	set(hazard_):
		hazard = hazard_
		%Hazard.text = str(hazard)
	get:
		return hazard
