@tool
class_name Trail extends TextureButton


@export_enum("north", "east", "south", "west") var windrose: String = "south":
	set(windrose_):
		windrose = windrose_
		var windroses = ["north", "east", "south", "west"]
		var directions = ["up", "right", "down", "left"]
		var index = windroses.find(windrose)
		#var index = Global.arr.windrose.find(windrose)
		var active_directions = []
		#var inactive_directions = []
		
		match index % 2:
			0:
				active_directions = ["up", "down"]
				#inactive_directions = ["right", "left"]
			1:
				active_directions = ["right", "left"]
				#inactive_directions = ["up", "down"]
		
		#for direction in Global.arr.direction:
		for direction in directions:
			var rect = get(direction)
			rect.visible = active_directions.has(direction)
			
			if active_directions.has(direction):
				rect.texture = load("res://entities/trail/images/" + windrose + ".png")
	
@export var value: int:
	set(value_):
		value = value_
		weight.text = str(value)
	get:
		return value

@export var weight: Label
@export var up: TextureRect
@export var right: TextureRect
@export var down: TextureRect
@export var left: TextureRect
